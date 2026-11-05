import 'package:akashic/layers/functional/Settings/domain/gateways/settings_gateway.dart';

class ManageRecentSearches {
  const ManageRecentSearches(this._settings);

  static const int kept = 4;

  final SettingsGateway _settings;

  Stream<List<String>> watch() => _settings.watchRecentSearches();

  Future<void> remember(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final current = await _settings.watchRecentSearches().first;
    await _settings.saveRecentSearches([trimmed, ...current.where((recent) => recent.toLowerCase() != trimmed.toLowerCase())].take(kept).toList());
  }

  Future<void> forget(String query) async => _settings.saveRecentSearches([for (final recent in await _settings.watchRecentSearches().first) if (recent != query) recent]);
}
