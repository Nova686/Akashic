import 'package:akashic/layers/functional/Releases/data/calendars/artist_album_calendar.dart';
import 'package:akashic/layers/functional/Releases/data/calendars/card_set_calendars.dart';
import 'package:akashic/layers/functional/Releases/data/calendars/next_volume_calendar.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_calendar.dart';
import 'package:http/http.dart' as http;

List<ReleaseCalendar> releaseCalendars(http.Client Function(String calendarKey) clientFor, {required String googleBooksApiKey}) => [
      TcgdexSetCalendar(clientFor('tcgdex-sets')),
      ScryfallSetCalendar(clientFor('scryfall-sets')),
      YgoprodeckSetCalendar(clientFor('ygoprodeck-sets')),
      LorcastSetCalendar(clientFor('lorcast-sets')),
      RiftcodexSetCalendar(clientFor('riftcodex-sets')),
      ArtistAlbumCalendar(clientFor('deezer-releases')),
      NextVolumeCalendar(clientFor('googlebooks-releases'), apiKey: googleBooksApiKey),
    ];
