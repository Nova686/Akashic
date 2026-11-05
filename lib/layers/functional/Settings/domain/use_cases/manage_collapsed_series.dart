import 'package:akashic/layers/functional/Settings/domain/gateways/settings_gateway.dart';

class ManageCollapsedSeries {
  const ManageCollapsedSeries(this._gateway);

  final SettingsGateway _gateway;

  Stream<Set<String>> watch() => _gateway.watchCollapsedSeries();

  Future<Set<String>> toggle(String seriesId) async {
    final current = await _gateway.watchCollapsedSeries().first;
    final updated = current.contains(seriesId) ? ({...current}..remove(seriesId)) : {...current, seriesId};
    await _gateway.saveCollapsedSeries(updated);
    return updated;
  }

  Future<Set<String>> setCollapsed(Iterable<String> seriesIds, {required bool collapsed}) async {
    final current = await _gateway.watchCollapsedSeries().first;
    final updated = collapsed ? {...current, ...seriesIds} : current.difference(seriesIds.toSet());
    await _gateway.saveCollapsedSeries(updated);
    return updated;
  }
}
