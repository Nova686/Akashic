import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Releases/data/calendars/release_date.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/release_interests.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_calendar.dart';
import 'package:http/http.dart' as http;

abstract class CardSetCalendar implements ReleaseCalendar {
  CardSetCalendar(this.client);

  final http.Client client;

  CardGame get game;

  @override
  String get key => '${game.sourceKey}-sets';

  @override
  bool get isConfigured => true;

  @override
  Future<List<UpcomingRelease>> upcoming(ReleaseInterests interests, {required DateTime today}) async {
    if (!interests.cardGames.contains(game)) {
      return const [];
    }
    return [
      for (final release in await announcedSets())
        if (!release.isOutBy(today.subtract(recentReleaseWindow))) release,
    ];
  }

  Future<List<UpcomingRelease>> announcedSets();

  UpcomingRelease? setRelease({required Object? setId, required Object? name, required Object? releasedOn, String? imageUrl}) {
    final identifier = textOf(setId);
    final setName = textOf(name);
    final releaseDate = releaseDateOf(releasedOn);
    if (identifier == null || setName == null || releaseDate == null) {
      return null;
    }
    return UpcomingRelease(
      sourceKey: game.sourceKey,
      externalId: 'set:$identifier',
      kind: ReleaseKind.cardSet,
      subject: game.displayName,
      title: setName,
      releaseDate: releaseDate.date,
      datePrecision: releaseDate.precision,
      imageUrl: imageUrl,
    );
  }
}

class ScryfallSetCalendar extends CardSetCalendar {
  ScryfallSetCalendar(super.client);

  static const Set<String> collectedSetTypes = {'core', 'expansion', 'masters', 'draft_innovation', 'commander', 'starter', 'box', 'funny', 'arsenal', 'from_the_vault', 'spellbook', 'premium_deck', 'duel_deck'};

  @override
  CardGame get game => CardGame.magic;

  @override
  Future<List<UpcomingRelease>> announcedSets() async {
    final json = mapOf(await sourceGetJson(client, Uri.https('api.scryfall.com', '/sets'), sourceKey: key, headers: const {'Accept': 'application/json'}));
    return [
      for (final set in listOf(json['data']).map(mapOf))
        if (set['digital'] != true && collectedSetTypes.contains(set['set_type']))
          ?setRelease(setId: set['code'], name: set['name'], releasedOn: set['released_at']),
    ];
  }
}

class TcgdexSetCalendar extends CardSetCalendar {
  TcgdexSetCalendar(super.client);

  @override
  CardGame get game => CardGame.pokemon;

  @override
  Future<List<UpcomingRelease>> announcedSets() async {
    final json = mapOf(await sourcePostJson(
      client,
      Uri.https('api.tcgdex.net', '/v2/graphql'),
      sourceKey: key,
      body: const {'query': '{ sets { id name releaseDate logo } }'},
    ));
    return [
      for (final set in listOf(mapOf(json['data'])['sets']).map(mapOf))
        ?setRelease(setId: set['id'], name: set['name'], releasedOn: set['releaseDate'], imageUrl: textOf(set['logo']) == null ? null : '${textOf(set['logo'])}.png'),
    ];
  }
}

class LorcastSetCalendar extends CardSetCalendar {
  LorcastSetCalendar(super.client);

  @override
  CardGame get game => CardGame.lorcana;

  @override
  Future<List<UpcomingRelease>> announcedSets() async {
    final json = mapOf(await sourceGetJson(client, Uri.https('api.lorcast.com', '/v0/sets'), sourceKey: key));
    return [
      for (final set in listOf(json['results']).map(mapOf)) ?setRelease(setId: set['id'], name: set['name'], releasedOn: set['released_at']),
    ];
  }
}

class YgoprodeckSetCalendar extends CardSetCalendar {
  YgoprodeckSetCalendar(super.client);

  @override
  CardGame get game => CardGame.yugioh;

  @override
  Future<List<UpcomingRelease>> announcedSets() async {
    final sets = listOf(await sourceGetJson(client, Uri.https('db.ygoprodeck.com', '/api/v7/cardsets.php'), sourceKey: key));
    return [
      for (final set in sets.map(mapOf))
        ?setRelease(setId: set['set_code'], name: set['set_name'], releasedOn: set['tcg_date'], imageUrl: httpsUrl(set['set_image'])),
    ];
  }
}

class RiftcodexSetCalendar extends CardSetCalendar {
  RiftcodexSetCalendar(super.client);

  @override
  CardGame get game => CardGame.riftbound;

  @override
  Future<List<UpcomingRelease>> announcedSets() async {
    final json = mapOf(await sourceGetJson(client, Uri.https('api.riftcodex.com', '/sets', {'size': '100'}), sourceKey: key));
    return [
      for (final set in listOf(json['items']).map(mapOf)) ?setRelease(setId: set['set_id'], name: set['name'], releasedOn: set['published_on']),
    ];
  }
}
