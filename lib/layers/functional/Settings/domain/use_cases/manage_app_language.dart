import 'package:akashic/layers/functional/Settings/domain/gateways/settings_gateway.dart';

class ManageAppLanguage {
  const ManageAppLanguage(this._gateway);

  static const List<String> supportedLanguageCodes = ['fr', 'en'];

  final SettingsGateway _gateway;

  Stream<String?> watch() => _gateway.watchAppLanguageCode();

  Future<void> choose(String? languageCode) => _gateway.saveAppLanguageCode(languageCode);
}
