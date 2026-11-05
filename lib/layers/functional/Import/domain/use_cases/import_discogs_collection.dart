import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:equatable/equatable.dart';

abstract interface class OwnedReleaseCatalogue {
  bool get isConfigured;
  Future<List<SourceMatch>> ownedReleases({void Function(int loaded, int total)? onProgress});
}

class DiscogsImportOutcome extends Equatable {
  const DiscogsImportOutcome({required this.added, required this.alreadyOwned, required this.failed});

  final int added;
  final int alreadyOwned;
  final int failed;

  @override
  List<Object?> get props => [added, alreadyOwned, failed];
}

class ImportDiscogsCollection {
  const ImportDiscogsCollection(this._catalogue, this._collection, this._addFromMatch);

  final OwnedReleaseCatalogue _catalogue;
  final CollectionGateway _collection;
  final AddFromMatch _addFromMatch;

  bool get isConfigured => _catalogue.isConfigured;

  Future<DiscogsImportOutcome> call({required String categoryId, void Function(int done, int total)? onProgress}) async {
    final releases = await _catalogue.ownedReleases();
    var added = 0;
    var alreadyOwned = 0;
    var failed = 0;
    for (final (index, release) in releases.indexed) {
      if (await _collection.findByExternalWork(release.sourceKey, release.externalWorkId) != null) {
        alreadyOwned++;
      } else {
        try {
          await _addFromMatch(release, categoryId: categoryId);
          added++;
        } on Exception {
          failed++;
        }
      }
      onProgress?.call(index + 1, releases.length);
    }
    return DiscogsImportOutcome(added: added, alreadyOwned: alreadyOwned, failed: failed);
  }
}
