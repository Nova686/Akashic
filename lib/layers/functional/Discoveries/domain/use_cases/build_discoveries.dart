import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/discovery_cache.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/dismissed_suggestion_gateway.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/recommendation_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';

class DiscoveriesUnavailable implements Exception {
  const DiscoveriesUnavailable();
}

class _Seed {
  const _Seed(this.work, this.type, this.source);

  final OwnedWork work;
  final CategoryType type;
  final RecommendationSource source;
}

class BuildDiscoveries {
  BuildDiscoveries(
    this._sources,
    this._collection,
    this._categories,
    this._dismissed,
    this._cache, {
    DateTime Function()? now,
    this._deadline = const Duration(seconds: 10),
  }) : _now = now ?? DateTime.now;

  static const int maximumSeeds = 12;
  static const int suggestionsPerGroup = 10;

  final List<RecommendationSource> _sources;
  final CollectionGateway _collection;
  final CategoryGateway _categories;
  final DismissedSuggestionGateway _dismissed;
  final DiscoveryCacheGateway _cache;
  final DateTime Function() _now;
  final Duration _deadline;

  Future<Discoveries?> cached() => _cache.read();

  Stream<Set<String>> watchOwnedIdentities() => _collection.watchOwnedWorks().map(_ownedIdentities);

  Future<Discoveries> call({required String languageCode, required PreferredLanguages preferredLanguages}) async {
    final owned = await _collection.watchOwnedWorks().first;
    final seeds = await _chooseSeeds(owned);
    if (seeds.isEmpty) {
      final empty = Discoveries(groups: const [], computedAt: _now(), seedCount: 0);
      await _cache.write(empty);
      return empty;
    }
    final answers = await Future.wait(seeds.map((seed) => _ask(seed, languageCode)));
    if (answers.every((answer) => answer == null)) {
      throw const DiscoveriesUnavailable();
    }
    final excluded = {..._ownedIdentities(owned), ...await _dismissed.identities()};
    final groups = <SuggestionGroup>[];
    for (final (index, seed) in seeds.indexed) {
      final suggestions = <Suggestion>[];
      for (final suggestion in answers[index] ?? const <Suggestion>[]) {
        if (suggestions.length == suggestionsPerGroup || suggestion.isExcludedBy(excluded)) {
          continue;
        }
        suggestions.add(suggestion);
        excluded.addAll({suggestion.sourceIdentity, suggestion.workIdentity});
      }
      if (suggestions.isNotEmpty) {
        groups.add(SuggestionGroup(
          seedItemId: seed.work.itemId,
          seedTitle: resolveDisplayTitle(seed.work.titles, preferredLanguages) ?? '',
          categoryType: seed.type,
          suggestions: suggestions,
        ));
      }
    }
    final discoveries = Discoveries(groups: groups, computedAt: _now(), seedCount: seeds.length);
    await _cache.write(discoveries);
    return discoveries;
  }

  Future<List<_Seed>> _chooseSeeds(List<OwnedWork> owned) async {
    final typesByCategory = <String, CategoryType>{
      for (final node in await _categories.watchTree().first) ...{
        node.category.id: node.category.type,
        for (final child in node.children) child.id: child.type,
      },
    };
    final candidates = <_Seed>[];
    for (final work in owned) {
      final type = typesByCategory[work.categoryId];
      if (type == null) {
        continue;
      }
      for (final source in _sources) {
        if (source.isConfigured && source.supports(work, type)) {
          candidates.add(_Seed(work, type, source));
          break;
        }
      }
    }
    int preference(_Seed first, _Seed second) {
      final byRating = (second.work.rating ?? 0).compareTo(first.work.rating ?? 0);
      return byRating != 0 ? byRating : (second.work.addedAt ?? DateTime(0)).compareTo(first.work.addedAt ?? DateTime(0));
    }

    final queuesByType = <CategoryType, List<_Seed>>{};
    for (final seed in candidates) {
      queuesByType.putIfAbsent(seed.type, () => []).add(seed);
    }
    final queues = [for (final queue in queuesByType.values) queue..sort(preference)]..sort((first, second) => preference(first.first, second.first));
    final chosen = <_Seed>[];
    final queried = <String>{};
    final seedsPerSource = <String, int>{};
    var hasTaken = true;
    while (chosen.length < maximumSeeds && hasTaken) {
      hasTaken = false;
      for (final queue in queues) {
        while (queue.isNotEmpty && chosen.length < maximumSeeds) {
          final seed = queue.removeAt(0);
          final sourceKey = seed.source.key;
          if ((seedsPerSource[sourceKey] ?? 0) >= seed.source.maximumSeeds || !queried.add('$sourceKey|${seed.source.queryKeyFor(seed.work)}')) {
            continue;
          }
          chosen.add(seed);
          seedsPerSource[sourceKey] = (seedsPerSource[sourceKey] ?? 0) + 1;
          hasTaken = true;
          break;
        }
      }
    }
    return chosen;
  }

  Future<List<Suggestion>?> _ask(_Seed seed, String languageCode) async {
    try {
      return await seed.source.recommendationsFor(seed.work, languageCode: languageCode).timeout(_deadline);
    } on SourceUnavailable {
      return null;
    } on TimeoutException {
      return null;
    }
  }

  Set<String> _ownedIdentities(List<OwnedWork> owned) {
    return {
      for (final work in owned) ...{
        if (work.sourceKey != null && work.externalWorkId != null) sourceIdentityOf(work.sourceKey!, work.externalWorkId!),
        for (final title in work.titles.byLanguage.values) ...{
          workIdentityOf(title, work.creator),
          if (work.creator == null) titleIdentityOf(title),
        },
      },
    };
  }
}
