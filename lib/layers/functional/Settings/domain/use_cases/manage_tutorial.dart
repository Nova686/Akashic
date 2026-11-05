import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Settings/domain/gateways/settings_gateway.dart';

class ManageTutorial {
  const ManageTutorial(this._settings, this._categories);

  final SettingsGateway _settings;
  final CategoryGateway _categories;

  Future<bool> shouldShowOnFirstLaunch() async {
    if (await _settings.hasSeenTutorial()) {
      return false;
    }
    if ((await _categories.watchTree().first).isNotEmpty) {
      await _settings.markTutorialSeen();
      return false;
    }
    return true;
  }

  Future<void> markSeen() => _settings.markTutorialSeen();
}
