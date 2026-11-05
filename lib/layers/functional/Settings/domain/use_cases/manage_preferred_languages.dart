import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/domain/gateways/settings_gateway.dart';

class ManagePreferredLanguages {
  const ManagePreferredLanguages(this._gateway);

  final SettingsGateway _gateway;

  Stream<PreferredLanguages> watch() => _gateway.watchPreferredLanguages();

  Future<PreferredLanguages> current() => _gateway.watchPreferredLanguages().first;

  Future<PreferredLanguages> add(String code) => _update((languages) => languages.add(code));

  Future<PreferredLanguages> remove(String code) => _update((languages) => languages.remove(code));

  Future<PreferredLanguages> move(int from, int to) => _update((languages) => languages.move(from, to));

  Future<PreferredLanguages> _update(PreferredLanguages Function(PreferredLanguages languages) change) async {
    final updated = change(await current());
    await _gateway.savePreferredLanguages(updated);
    return updated;
  }
}
