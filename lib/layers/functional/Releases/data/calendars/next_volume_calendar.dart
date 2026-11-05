import 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/volume_title.dart';
import 'package:akashic/layers/functional/Releases/data/calendars/release_date.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/release_interests.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_calendar.dart';
import 'package:akashic/layers/functional/Releases/domain/use_cases/estimate_next_volume.dart';
import 'package:akashic/layers/functional/Releases/data/calendars/keeping_what_succeeded.dart';
import 'package:http/http.dart' as http;

class NextVolumeCalendar implements ReleaseCalendar {
  NextVolumeCalendar(this._client, {required this._apiKey});

  static const String sourceKey = 'googlebooks';

  final http.Client _client;
  final String _apiKey;

  @override
  String get key => 'googlebooks-releases';

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  Future<List<UpcomingRelease>> upcoming(ReleaseInterests interests, {required DateTime today}) async {
    return keepingWhatSucceeded([for (final series in interests.series) () async => [?await _nextVolumeOf(series, today)]]);
  }

  Future<UpcomingRelease?> _nextVolumeOf(FollowedSeries series, DateTime today) async {
    final json = mapOf(await sourceGetJson(
      _client,
      Uri.https('www.googleapis.com', '/books/v1/volumes', {
        'q': 'intitle:"${series.title.replaceAll('"', '')}" ${series.nextVolume}',
        'orderBy': 'newest',
        'printType': 'books',
        'maxResults': '20',
        'key': _apiKey,
      }),
      sourceKey: key,
    ));
    final seriesIdentity = titleIdentityOf(series.title);
    final datesByVolume = <int, DateTime>{};
    for (final volume in listOf(json['items']).map(mapOf)) {
      final info = mapOf(volume['volumeInfo']);
      final volumeId = textOf(volume['id']);
      final title = textOf(info['title']);
      final releaseDate = releaseDateOf(info['publishedDate']);
      if (volumeId == null || title == null || releaseDate == null) {
        continue;
      }
      final fullTitle = [title, ?textOf(info['subtitle'])].join(' - ');
      final numbered = parseVolumeTitle(fullTitle) ?? parseVolumeTitle(title);
      if (numbered == null || titleIdentityOf(numbered.seriesTitle) != seriesIdentity) {
        continue;
      }
      if (numbered.volumeNumber != series.nextVolume) {
        if (releaseDate.precision != ReleaseDatePrecision.year) {
          datesByVolume[numbered.volumeNumber] = releaseDate.date;
        }
        continue;
      }
      return UpcomingRelease(
        sourceKey: sourceKey,
        externalId: volumeId,
        kind: ReleaseKind.nextVolume,
        subject: series.title,
        title: fullTitle,
        releaseDate: releaseDate.date,
        datePrecision: releaseDate.precision,
        imageUrl: httpsUrl(mapOf(info['imageLinks'])['thumbnail']),
        isWished: series.isWished,
      );
    }
    final estimate = estimateVolumeDate(datesByVolume, series.nextVolume);
    if (estimate == null || estimate.isBefore(DateTime(today.year, today.month))) {
      return null;
    }
    return UpcomingRelease(
      sourceKey: sourceKey,
      externalId: 'estimate:${series.seriesId}:${series.nextVolume}',
      kind: ReleaseKind.nextVolume,
      subject: series.title,
      title: '${series.title} ${series.nextVolume}',
      releaseDate: estimate,
      datePrecision: ReleaseDatePrecision.month,
      isEstimated: true,
      isWished: series.isWished,
    );
  }
}
