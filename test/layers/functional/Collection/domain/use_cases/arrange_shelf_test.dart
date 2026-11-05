import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/arrange_shelf.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:flutter_test/flutter_test.dart';

CollectionItem book(String id, String title, {int? year, int? rating, ProgressStatus? status, DateTime? addedAt}) => CollectionItem(
      id: id,
      categoryId: 'books',
      titles: LocalizedTitles(byLanguage: {'fr': title}),
      year: year,
      rating: rating,
      progress: status == null ? null : ItemProgress(status: status),
      addedAt: addedAt,
    );

void main() {
  final dune = book('dune', 'Dune', year: 1965, rating: 5, status: ProgressStatus.finished, addedAt: DateTime(2026, 1, 1));
  final atlas = book('atlas', 'Atlas', year: 2001, rating: 3, addedAt: DateTime(2026, 3, 1));
  final berserk = book('berserk', 'Berserk', rating: 4, status: ProgressStatus.inProgress, addedAt: DateTime(2026, 2, 1));
  final groups = [
    ShelfGroup(id: 'series', label: 'Série', entries: [ShelfItem(berserk), const ShelfMissingVolume(seriesId: 'series', volumeNumber: 2)], isSeries: true, ownedCount: 1),
    ShelfGroup(id: 'others', label: '', entries: [ShelfItem(dune), ShelfItem(atlas)], isSeries: false, ownedCount: 2),
  ];

  List<String> idsOf(List<ShelfGroup> arranged) => [
        for (final group in arranged)
          for (final entry in group.entries)
            if (entry case ShelfItem(:final item)) item.id,
      ];

  List<ShelfGroup> arrange(ShelfSort sort, [ShelfFilter filter = const ShelfFilter()]) => arrangeShelf(groups, sort: sort, filter: filter, languages: PreferredLanguages.defaults);

  test('without sort nor filter the series layout is kept as is', () {
    expect(arrange(ShelfSort.bySeries), same(groups));
  });

  test('sorting by title puts each initial on its own shelf, without missing volumes', () {
    final arranged = arrange(ShelfSort.title);
    expect(arranged.map((group) => group.label), ['A', 'B', 'D']);
    expect(arranged.every(isArrangedGroup), isTrue);
    expect(idsOf(arranged), ['atlas', 'berserk', 'dune']);
  });

  test('each author, year, rating and addition year gets its own shelf, unknown ones last', () {
    final byAuthor = arrangeShelf(
      [
        ShelfGroup(id: 'others', label: '', isSeries: false, ownedCount: 3, entries: [
          ShelfItem(book('dune', 'Dune').copyWithCreator('Frank Herbert')),
          ShelfItem(book('atlas', 'Atlas')),
          ShelfItem(book('messiah', 'Le Messie de Dune').copyWithCreator('frank herbert')),
        ]),
      ],
      sort: ShelfSort.creator,
      filter: const ShelfFilter(),
      languages: PreferredLanguages.defaults,
    );
    expect(byAuthor.map((group) => group.label), ['Frank Herbert', '']);
    expect(byAuthor.first.ownedCount, 2);
    expect(arrange(ShelfSort.newest).map((group) => group.label), ['2001', '1965', '']);
    expect(arrange(ShelfSort.bestRated).map((group) => group.label), ['★★★★★', '★★★★', '★★★']);
    expect(arrange(ShelfSort.recentlyAdded).map((group) => group.label), ['2026']);
  });

  test('a filter on the series layout keeps the series and drops what does not match', () {
    final arranged = arrange(ShelfSort.bySeries, const ShelfFilter(minimumRating: 4));
    expect(arranged.map((group) => group.id), ['series', 'others']);
    expect(idsOf(arranged), ['berserk', 'dune']);
    expect(arranged.first.isIncomplete, isFalse);
  });

  test('years, ratings and additions sort with unknown values last', () {
    expect(idsOf(arrange(ShelfSort.newest)), ['atlas', 'dune', 'berserk']);
    expect(idsOf(arrange(ShelfSort.oldest)), ['dune', 'atlas', 'berserk']);
    expect(idsOf(arrange(ShelfSort.bestRated)), ['dune', 'berserk', 'atlas']);
    expect(idsOf(arrange(ShelfSort.recentlyAdded)), ['atlas', 'berserk', 'dune']);
  });

  test('the to-read pile counts items without status, and ratings filter from a minimum', () {
    expect(idsOf(arrange(ShelfSort.bySeries, const ShelfFilter(progressStatus: ProgressStatus.notStarted))), ['atlas']);
    expect(idsOf(arrange(ShelfSort.bySeries, const ShelfFilter(progressStatus: ProgressStatus.inProgress))), ['berserk']);
    expect(idsOf(arrange(ShelfSort.title, const ShelfFilter(minimumRating: 4))), ['berserk', 'dune']);
  });
}

extension on CollectionItem {
  CollectionItem copyWithCreator(String creator) => CollectionItem(id: id, categoryId: categoryId, titles: titles, creator: creator, year: year, rating: rating, progress: progress, addedAt: addedAt);
}
