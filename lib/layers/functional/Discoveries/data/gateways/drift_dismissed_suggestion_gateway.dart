import 'package:akashic/layers/functional/Discoveries/domain/gateways/dismissed_suggestion_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftDismissedSuggestionGateway implements DismissedSuggestionGateway {
  DriftDismissedSuggestionGateway(this._database);

  static const String _separator = '|';

  final AkashicDatabase _database;

  @override
  Future<Set<String>> identities() async {
    final rows = await _database.select(_database.dismissedSuggestions).get();
    return {for (final row in rows) '${row.sourceKey}$_separator${row.externalWorkId}'};
  }

  @override
  Future<void> dismiss(Set<String> identities) {
    return _database.batch((batch) {
      for (final identity in identities) {
        final separatorIndex = identity.indexOf(_separator);
        batch.insert(
          _database.dismissedSuggestions,
          DismissedSuggestionsCompanion.insert(sourceKey: identity.substring(0, separatorIndex), externalWorkId: identity.substring(separatorIndex + 1)),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }
}
