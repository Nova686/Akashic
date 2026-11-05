import 'package:akashic/layers/functional/Settings/data/gateways/drift_settings_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => AkashicColors.useHighContrast(false));

  test('the high-contrast palette brightens text and borders, accents stay the same', () {
    final standard = (AkashicColors.text, AkashicColors.textSoft, AkashicColors.textFaint, AkashicColors.line, AkashicColors.lavender);
    AkashicColors.useHighContrast(true);
    expect(AkashicColors.isHighContrast, isTrue);
    expect(AkashicColors.textSoft.computeLuminance(), greaterThan(standard.$2.computeLuminance()));
    expect(AkashicColors.textFaint.computeLuminance(), greaterThan(standard.$3.computeLuminance()));
    expect(AkashicColors.line.computeLuminance(), greaterThan(standard.$4.computeLuminance()));
    expect(AkashicColors.lavender, standard.$5);
    AkashicColors.useHighContrast(false);
    expect((AkashicColors.text, AkashicColors.textSoft), (standard.$1, standard.$2));
  });

  test('high contrast is the default and turning it off is remembered', () async {
    final database = AkashicDatabase.forTesting();
    addTearDown(database.close);
    final settings = DriftSettingsGateway(database);
    expect(await settings.watchHighContrast().first, isTrue);
    await settings.saveHighContrast(false);
    expect(await settings.watchHighContrast().first, isFalse);
    await settings.saveHighContrast(true);
    expect(await settings.watchHighContrast().first, isTrue);
  });
}
