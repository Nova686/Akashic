import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_completion.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';
import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/map_import_columns.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Wishes/domain/gateways/wish_gateway.dart';
import 'package:equatable/equatable.dart';

enum ExchangeReason { fillsMissingVolume, wished }

class ComparedWork extends Equatable {
  const ComparedWork({required this.title, this.creator, this.seriesTitle, this.volumeNumber, this.reason});

  final String title;
  final String? creator;
  final String? seriesTitle;
  final int? volumeNumber;
  final ExchangeReason? reason;

  String get label => switch ((seriesTitle, volumeNumber)) {
        (final series?, final volume?) => '$series · $volume',
        _ => title,
      };

  String get key => comparisonKeyOf(title: title, creator: creator, seriesTitle: seriesTitle, volumeNumber: volumeNumber);

  @override
  List<Object?> get props => [title, creator, seriesTitle, volumeNumber, reason];
}

class CollectionComparison extends Equatable {
  const CollectionComparison({required this.friendCount, required this.myCount, required this.inCommon, required this.onlyFriend, required this.onlyMine});

  final int friendCount;
  final int myCount;
  final List<ComparedWork> inCommon;
  final List<ComparedWork> onlyFriend;
  final List<ComparedWork> onlyMine;

  List<ComparedWork> get exchangeIdeas => [for (final work in onlyFriend) if (work.reason != null) work];

  @override
  List<Object?> get props => [friendCount, myCount, inCommon, onlyFriend, onlyMine];
}

String comparisonKeyOf({required String title, String? creator, String? seriesTitle, int? volumeNumber}) => switch ((seriesTitle, volumeNumber)) {
      (final series?, final volume?) when series.trim().isNotEmpty => 'series|${normalizeForSearch(series)}|$volume',
      _ => normalizeForSearch(title).isEmpty ? '' : titleIdentityOf(title),
    };

List<ComparedWork> friendWorksOf(ImportTable table) => [
      for (final line in importLinesOf(table, guessColumnMapping(table.headers)))
        if (line.title?.trim() case final title? when title.isNotEmpty)
          ComparedWork(title: title, creator: line.creator, seriesTitle: line.seriesTitle, volumeNumber: line.volumeNumber),
    ];

class CompareCollections {
  CompareCollections(this._collection, this._wishes);

  final CollectionGateway _collection;
  final WishGateway _wishes;

  Future<CollectionComparison> call(List<ComparedWork> friend) async {
    final seriesById = {for (final series in await _collection.watchAllSeries().first) series.id: series};
    final mine = <String, ComparedWork>{};
    for (final item in await _collection.allItems()) {
      final title = resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? '';
      final series = seriesById[item.seriesId];
      final work = ComparedWork(title: title, creator: item.creator, seriesTitle: series == null ? null : resolveDisplayTitle(series.titles, PreferredLanguages.defaults), volumeNumber: item.volumeNumber);
      if (work.key.isNotEmpty) {
        mine[work.key] = work;
      }
    }
    final owned = await _collection.ownedVolumesBySeries();
    final missingKeys = <String>{
      for (final series in seriesById.values)
        for (final volume in computeSeriesCompletion(series, owned[series.id] ?? const {}).missing)
          comparisonKeyOf(title: '', seriesTitle: resolveDisplayTitle(series.titles, PreferredLanguages.defaults), volumeNumber: volume),
    };
    final wishes = await _wishes.all();
    final wishedKeys = <String>{
      for (final wish in wishes) ...[
        titleIdentityOf(wish.title),
        workIdentityOf(wish.title, wish.creator),
      ],
    };
    final friendByKey = <String, ComparedWork>{};
    for (final work in friend) {
      if (work.key.isEmpty) {
        continue;
      }
      final reason = missingKeys.contains(work.key)
          ? ExchangeReason.fillsMissingVolume
          : (wishedKeys.contains(titleIdentityOf(work.title)) || wishedKeys.contains(workIdentityOf(work.title, work.creator)) ? ExchangeReason.wished : null);
      friendByKey[work.key] = ComparedWork(title: work.title, creator: work.creator, seriesTitle: work.seriesTitle, volumeNumber: work.volumeNumber, reason: reason);
    }
    int byLabel(ComparedWork first, ComparedWork second) => normalizeForSearch(first.label).compareTo(normalizeForSearch(second.label));
    return CollectionComparison(
      friendCount: friendByKey.length,
      myCount: mine.length,
      inCommon: [for (final entry in friendByKey.entries) if (mine.containsKey(entry.key)) entry.value]..sort(byLabel),
      onlyFriend: [for (final entry in friendByKey.entries) if (!mine.containsKey(entry.key)) entry.value]..sort((first, second) {
          final byReason = (first.reason == null ? 1 : 0).compareTo(second.reason == null ? 1 : 0);
          return byReason != 0 ? byReason : byLabel(first, second);
        }),
      onlyMine: [for (final entry in mine.entries) if (!friendByKey.containsKey(entry.key)) entry.value]..sort(byLabel),
    );
  }
}
