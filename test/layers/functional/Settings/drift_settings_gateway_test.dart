import 'package:akashic/layers/functional/Settings/data/gateways/drift_settings_gateway.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AkashicDatabase database;
  late DriftSettingsGateway gateway;

  setUp(() {
    database = AkashicDatabase.forTesting();
    gateway = DriftSettingsGateway(database);
  });
  tearDown(() => database.close());

  test('defaults are french then english when nothing is stored', () async {
    expect((await gateway.watchPreferredLanguages().first).codes, ['fr', 'en']);
  });

  test('saved preferred languages are read back in order', () async {
    await gateway.savePreferredLanguages(const PreferredLanguages(['ja', 'en']));
    expect((await gateway.watchPreferredLanguages().first).codes, ['ja', 'en']);
  });

  test('app language null follows the device', () async {
    expect(await gateway.watchAppLanguageCode().first, isNull);
    await gateway.saveAppLanguageCode('en');
    expect(await gateway.watchAppLanguageCode().first, 'en');
    await gateway.saveAppLanguageCode(null);
    expect(await gateway.watchAppLanguageCode().first, isNull);
  });

  test('collapsed series are persisted', () async {
    expect(await gateway.watchCollapsedSeries().first, isEmpty);
    await gateway.saveCollapsedSeries({'one-piece', 'frieren'});
    expect(await gateway.watchCollapsedSeries().first, {'one-piece', 'frieren'});
  });
}
