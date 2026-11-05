import 'dart:math';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';

enum TonightActivity { any, read, play, watch, listen }

enum TonightLength { any, short, medium, long }

TonightActivity activityOf(CategoryType type) => switch (type) {
      CategoryType.books || CategoryType.manga || CategoryType.comics => TonightActivity.read,
      CategoryType.videoGames || CategoryType.boardGames => TonightActivity.play,
      CategoryType.films => TonightActivity.watch,
      CategoryType.music => TonightActivity.listen,
      _ => TonightActivity.any,
    };

final RegExp _firstNumber = RegExp(r'\d+');

int? _numberIn(String text) => int.tryParse(_firstNumber.firstMatch(text)?.group(0) ?? '');

TonightLength? lengthOf(CollectionItem item, CategoryType type, ItemDetails? details) {
  if (type == CategoryType.manga || type == CategoryType.comics) {
    return TonightLength.short;
  }
  final facts = [
    if (details != null)
      for (final section in details.sections)
        if (section is FactsSection) ...section.facts,
  ];
  int? factNumber(FactKind kind) => [for (final fact in facts) if (fact.kind == kind) _numberIn(fact.value)].nonNulls.firstOrNull;
  if (factNumber(FactKind.pages) case final pages?) {
    return pages < 220 ? TonightLength.short : (pages < 450 ? TonightLength.medium : TonightLength.long);
  }
  if (factNumber(FactKind.runtime) case final minutes?) {
    return minutes < 95 ? TonightLength.short : (minutes < 140 ? TonightLength.medium : TonightLength.long);
  }
  if (type == CategoryType.music) {
    return TonightLength.short;
  }
  return null;
}

class TonightCandidate {
  const TonightCandidate({required this.item, required this.category, required this.activity, this.length});

  final CollectionItem item;
  final Category category;
  final TonightActivity activity;
  final TonightLength? length;
}

bool isWaitingToStart(CollectionItem item) => item.cardKind == null && (item.progress == null || item.progress!.status == ProgressStatus.notStarted);

class PickTonight {
  PickTonight({Random? random}) : _random = random ?? Random();

  final Random _random;
  final List<String> _recentlyDrawn = [];

  static const int rememberedDraws = 8;

  TonightCandidate? call(List<TonightCandidate> candidates, {TonightActivity activity = TonightActivity.any, TonightLength length = TonightLength.any}) {
    final matching = [
      for (final candidate in candidates)
        if ((activity == TonightActivity.any ? candidate.activity != TonightActivity.any : candidate.activity == activity) && (length == TonightLength.any || candidate.length == length)) candidate,
    ];
    if (matching.isEmpty) {
      return null;
    }
    final fresh = [for (final candidate in matching) if (!_recentlyDrawn.contains(candidate.item.id)) candidate];
    final pool = fresh.isEmpty ? matching : fresh;
    final picked = pool[_random.nextInt(pool.length)];
    _recentlyDrawn.add(picked.item.id);
    if (_recentlyDrawn.length > rememberedDraws) {
      _recentlyDrawn.removeAt(0);
    }
    return picked;
  }
}
