import 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';

class FindGameMatch {
  const FindGameMatch(this._games);

  final CatalogSource? _games;

  Future<SourceMatch?> call(SourceMatch provisional) async {
    final games = _games;
    final name = provisional.titles.byLanguage.values.firstOrNull;
    if (games == null || !games.isConfigured || name == null) {
      return null;
    }
    final identity = titleIdentityOf(name);
    return (await games.search(name)).where((match) => match.titles.byLanguage.values.any((title) => titleIdentityOf(title) == identity)).firstOrNull;
  }
}
