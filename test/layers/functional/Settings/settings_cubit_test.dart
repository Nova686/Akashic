import 'package:akashic/layers/functional/Settings/data/gateways/drift_settings_gateway.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_app_language.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/presentation/cubit/settings_cubit.dart';
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

  test('adding then moving a language persists the new order', () async {
    final cubit = SettingsCubit(ManagePreferredLanguages(gateway), ManageAppLanguage(gateway));
    await cubit.load();
    await cubit.addLanguage('ja');
    await cubit.moveLanguage(2, 0);
    expect((await gateway.watchPreferredLanguages().first).codes, ['ja', 'fr', 'en']);
    expect(cubit.state.preferredLanguages.codes, ['ja', 'fr', 'en']);
    await cubit.close();
  });

  test('removing the last language keeps it and flags the error', () async {
    final cubit = SettingsCubit(ManagePreferredLanguages(gateway), ManageAppLanguage(gateway));
    await cubit.load();
    await cubit.removeLanguage('en');
    await cubit.removeLanguage('fr');
    expect(cubit.state.preferredLanguages.codes, ['fr']);
    expect(cubit.state.lastLanguageRefused, isTrue);
    await cubit.close();
  });
}
