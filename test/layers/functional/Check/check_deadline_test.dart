import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/find_locally.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_registry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

class HangingSource implements CatalogSource {
  HangingSource(this.key, {this.answer});

  @override
  final String key;
  final List<SourceMatch>? answer;

  @override
  Set<CategoryType> get types => const {CategoryType.music};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => true;

  Future<List<SourceMatch>> _reply() => answer == null ? Completer<List<SourceMatch>>().future : Future.value(answer);

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) => _reply();

  @override
  Future<List<SourceMatch>> search(String query) => _reply();
}

void main() {
  test('a hanging source cannot delay the verdict past the overall deadline', () async {
    final harness = CollectionHarness();
    await harness.vinyls();
    final checkOwnership = CheckOwnership(
      FindLocally(harness.collection),
      SourceRegistry([
        HangingSource('discogs'),
        HangingSource('musicbrainz', answer: const [
          SourceMatch(sourceKey: 'musicbrainz', externalWorkId: 'blue-train', titles: LocalizedTitles(byLanguage: {'en': 'Blue Train'}), suggestedType: CategoryType.music),
        ]),
      ]),
      harness.collection,
      harness.categories,
      deadline: const Duration(milliseconds: 100),
    );
    final stopwatch = Stopwatch()..start();
    final verdict = await checkOwnership.barcode('0888751238211');
    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 2)));
    expect(verdict, isA<NotOwned>());
    expect((verdict as NotOwned).match?.externalWorkId, 'blue-train');
    await harness.database.close();
  });
}
