import 'package:akashic/layers/functional/Check/domain/use_cases/shelf_spines.dart';
import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/item_field.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_query_kind.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/cover_text_lines.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/find_locally.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/normalize_barcode.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_registry.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';

class CheckOwnership {
  CheckOwnership(this._findLocally, this._registry, this._collection, this._categories, {this._deadline = const Duration(seconds: 8)});

  final Duration _deadline;

  final FindLocally _findLocally;
  final SourceRegistry _registry;
  final CollectionGateway _collection;
  final CategoryGateway _categories;

  Future<CheckVerdict> barcode(String raw) => evaluate(CheckQueryKind.barcode, raw);

  Future<CheckVerdict> text(String text) => evaluate(CheckQueryKind.text, text);

  static const double _minimumSpineTitleCoverage = 0.6;

  Future<CheckVerdict> spine(String spineText) async {
    final spineWords = searchWordsOf(spineText);
    final volumeNumber = spineVolumeNumberOf(spineText);
    if (_ownedOnSpine(await _collection.allItems(), spineWords, volumeNumber) case final owned?) {
      return Owned(owned, await _collection.watchCopies(owned.id).first);
    }
    final query = spineSearchQueryOf(spineText);
    if (query.isEmpty) {
      return NotOwned(null, spineText);
    }
    final answers = await Future.wait([for (final source in await _textSources()) _ask(source, CheckQueryKind.text, query)]);
    final best = _bestSpineMatch([for (final answer in answers) ...?answer.matches], spineWords, volumeNumber);
    if (best == null) {
      return _withoutMatch(spineText, answers);
    }
    return _verdictFor(volumeNumber != null && best.volumeNumber == null && best.suggestedType.itemFields.contains(ItemField.series) ? _withVolume(best, volumeNumber) : best, spineText);
  }

  CollectionItem? _ownedOnSpine(List<CollectionItem> items, Set<String> spineWords, int? volumeNumber, {int minimumWords = 1}) {
    CollectionItem? best;
    var bestCoverage = 0;
    for (final item in items) {
      if (item.volumeNumber != null && item.volumeNumber != volumeNumber) {
        continue;
      }
      for (final title in item.titles.byLanguage.values) {
        final titleWords = searchWordsOf(title);
        final letters = titleWords.fold(0, (total, word) => total + word.length);
        if (letters >= 3 && titleWords.length >= minimumWords && titleWords.length > bestCoverage && titleWords.every((word) => hasWordLike(spineWords, word))) {
          best = item;
          bestCoverage = titleWords.length;
        }
      }
    }
    return best;
  }

  SourceMatch? _bestSpineMatch(List<SourceMatch> matches, Set<String> spineWords, int? volumeNumber) {
    SourceMatch? best;
    var bestScore = 0.0;
    for (final match in matches) {
      if (volumeNumber != null && match.volumeNumber != null && match.volumeNumber != volumeNumber) {
        continue;
      }
      var titleScore = 0.0;
      for (final title in [...match.titles.byLanguage.values, ?match.seriesTitle]) {
        final titleWords = searchWordsOf(title);
        if (titleWords.isNotEmpty) {
          final coverage = titleWords.where((word) => hasWordLike(spineWords, word)).length / titleWords.length;
          titleScore = coverage > titleScore ? coverage : titleScore;
        }
      }
      if (titleScore < _minimumSpineTitleCoverage) {
        continue;
      }
      final creatorWords = searchWordsOf(match.creator ?? '');
      final creatorScore = creatorWords.isEmpty ? 0.0 : creatorWords.where(spineWords.contains).length / creatorWords.length;
      final volumeScore = volumeNumber != null && match.volumeNumber == volumeNumber ? 0.5 : 0.0;
      final score = titleScore + creatorScore * 0.5 + volumeScore;
      if (score > bestScore) {
        best = match;
        bestScore = score;
      }
    }
    return best;
  }

  SourceMatch _withVolume(SourceMatch match, int volumeNumber) => SourceMatch(
        sourceKey: match.sourceKey,
        externalWorkId: match.externalWorkId,
        titles: match.titles,
        suggestedType: match.suggestedType,
        externalEditionId: match.externalEditionId,
        creator: match.creator,
        year: match.year,
        publisher: match.publisher,
        barcode: match.barcode,
        imageUrl: match.imageUrl,
        format: match.format,
        seriesTitle: match.seriesTitle ?? match.titles.byLanguage.values.firstOrNull,
        volumeNumber: volumeNumber,
        platform: match.platform,
        volumeCount: match.volumeCount,
        status: match.status,
      );

  Future<CheckVerdict> cover(List<String> prominentLines) async {
    final items = prominentLines.isEmpty ? const <CollectionItem>[] : await _collection.allItems();
    for (final line in prominentLines) {
      final owned = await _findLocally.bestTextMatch(line, among: items);
      if (owned != null) {
        return owned;
      }
    }
    final coverWords = searchWordsOf(prominentLines.join(' '));
    if (_ownedOnSpine(items, coverWords, spineVolumeNumberOf(prominentLines.join(' ')), minimumWords: 2) case final owned?) {
      return Owned(owned, await _collection.watchCopies(owned.id).first);
    }
    final queries = {
      if (prominentLines.length > 1) '${prominentLines[0]} ${prominentLines[1]}',
      ?prominentLines.firstOrNull,
    };
    final sources = await _textSources();
    final answers = <_SourceAnswer>[];
    for (final query in queries) {
      final queryAnswers = await Future.wait([for (final source in sources) _ask(source, CheckQueryKind.text, query)]);
      answers.addAll(queryAnswers);
      final best = _bestCoverMatch([for (final answer in queryAnswers) ...?answer.matches], coverWords);
      if (best != null) {
        return _verdictFor(best, prominentLines.first);
      }
    }
    return _withoutMatch(prominentLines.firstOrNull ?? '', answers);
  }

  SourceMatch? _bestCoverMatch(List<SourceMatch> matches, Set<String> coverWords) {
    SourceMatch? best;
    var bestScore = 0.0;
    for (final match in matches) {
      final titleWords = searchWordsOf([...match.titles.byLanguage.values, ?match.seriesTitle].join(' '));
      if (titleWords.isEmpty) {
        continue;
      }
      final creatorWords = searchWordsOf(match.creator ?? '');
      final titleScore = titleWords.where(coverWords.contains).length / titleWords.length;
      final creatorScore = creatorWords.isEmpty ? 0.0 : creatorWords.where(coverWords.contains).length / creatorWords.length;
      final score = titleScore + creatorScore * 0.5;
      if (titleScore > 0 && score > bestScore) {
        best = match;
        bestScore = score;
      }
    }
    return best;
  }

  Future<CheckVerdict> evaluate(CheckQueryKind kind, String rawQuery, {String? ignoringItemId}) async {
    final query = kind == CheckQueryKind.barcode ? (normalizeBarcode(rawQuery) ?? rawQuery.trim()) : rawQuery.trim();
    final local = kind == CheckQueryKind.barcode ? await _findLocally.byBarcode(query) : await _findLocally.bestTextMatch(query);
    if (local != null && local.item.id != ignoringItemId) {
      return local;
    }
    final sources = kind == CheckQueryKind.barcode ? _registry.barcodeSources(query) : await _textSources();
    final answers = await Future.wait([for (final source in sources) _ask(source, kind, query)]);
    for (final answer in answers) {
      if (answer.matches case final matches? when matches.isNotEmpty) {
        return _verdictFor(matches.first, query);
      }
    }
    if (kind == CheckQueryKind.barcode) {
      for (final fallback in _registry.barcodeFallbacksFor(query)) {
        final answer = await _ask(fallback, kind, query);
        if (answer.matches case final matches? when matches.isNotEmpty) {
          return _verdictFor(matches.first, query);
        }
        answers.add(answer);
      }
    }
    return _withoutMatch(query, answers);
  }

  CheckVerdict _withoutMatch(String query, List<_SourceAnswer> answers) {
    final failures = answers.map((answer) => answer.failure).nonNulls;
    final rateLimitedSources = {for (final failure in failures) if (failure.isRateLimited) failure.sourceKey}.toList();
    if (rateLimitedSources.isNotEmpty) {
      return CatalogsUnavailable(query, rateLimitedSources: rateLimitedSources);
    }
    if (answers.isNotEmpty && answers.every((answer) => answer.failure != null)) {
      return CatalogsUnavailable(query);
    }
    return NotOwned(null, query);
  }

  Future<_SourceAnswer> _ask(CatalogSource source, CheckQueryKind kind, String query) async {
    try {
      final request = kind == CheckQueryKind.barcode ? source.lookupBarcode(query) : source.search(query);
      return (matches: await request.timeout(_deadline), failure: null);
    } on SourceUnavailable catch (failure) {
      return (matches: null, failure: failure);
    } on TimeoutException {
      return (matches: null, failure: SourceUnavailable(source.key, 'timeout'));
    }
  }

  Future<List<CatalogSource>> _textSources() async {
    final tree = await _categories.watchTree().first;
    final types = {
      for (final node in tree) ...[node.category.type, ...node.children.map((child) => child.type)],
    };
    final ordered = <String, CatalogSource>{};
    for (final type in CategoryType.values.where(types.contains)) {
      for (final source in _registry.configuredFor(type)) {
        ordered.putIfAbsent(source.key, () => source);
      }
    }
    return ordered.values.toList();
  }

  Future<CheckVerdict> _verdictFor(SourceMatch match, String query) async {
    if (match.volumeNumber != null) {
      final ownedVolume = _ownedVolume(match, await _collection.allItems());
      return ownedVolume == null ? NotOwned(match, query) : OwnedOtherEdition(ownedVolume, await _collection.watchCopies(ownedVolume.id).first, match);
    }
    final ownedWork = await _collection.findByExternalWork(match.sourceKey, match.externalWorkId);
    if (ownedWork != null) {
      return OwnedOtherEdition(ownedWork, await _collection.watchCopies(ownedWork.id).first, match);
    }
    final sameTitle = await _sameTitleAndCreator(match, await _collection.allItems());
    if (sameTitle != null) {
      return OwnedOtherEdition(sameTitle.item, sameTitle.copies, match);
    }
    return NotOwned(match, query);
  }

  CollectionItem? _ownedVolume(SourceMatch match, List<CollectionItem> items) {
    final titles = {
      ...match.titles.byLanguage.values.map(normalizeForSearch),
      if (match.seriesTitle case final seriesTitle?) normalizeForSearch(seriesTitle),
    };
    for (final item in items) {
      if (item.volumeNumber != match.volumeNumber) {
        continue;
      }
      final sameWork = item.sourceKey == match.sourceKey && item.externalWorkId == match.externalWorkId;
      final sameTitle = item.titles.byLanguage.values.map(normalizeForSearch).any(titles.contains);
      if (sameWork || sameTitle) {
        return item;
      }
    }
    return null;
  }

  Future<({CollectionItem item, List<ItemCopy> copies})?> _sameTitleAndCreator(SourceMatch match, List<CollectionItem> items) async {
    final creator = match.creator == null ? null : normalizeForSearch(match.creator!);
    final titles = match.titles.byLanguage.values.map(normalizeForSearch).toSet();
    for (final item in items) {
      final sameTitle = item.titles.byLanguage.values.map(normalizeForSearch).any(titles.contains);
      final sameCreator = creator != null && item.creator != null && normalizeForSearch(item.creator!) == creator;
      if (sameTitle && sameCreator) {
        return (item: item, copies: await _collection.watchCopies(item.id).first);
      }
    }
    return null;
  }
}

typedef _SourceAnswer = ({List<SourceMatch>? matches, SourceUnavailable? failure});
