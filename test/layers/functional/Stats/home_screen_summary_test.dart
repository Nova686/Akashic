import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_gateway.dart';
import 'package:akashic/layers/functional/Stats/data/widget/home_screen_summary.dart';
import 'package:akashic/layers/technical/Localization/app_localizations_fr.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

void main() {
  test('the home screen summary counts items, shows the latest additions and loans', () async {
    final harness = CollectionHarness();
    final vinyls = await harness.vinyls();
    for (final title in ['Kind of Blue', 'Blue Train', 'Mingus Ah Um', 'Time Out']) {
      await harness.collection.saveItem(CollectionItem(id: title, categoryId: vinyls.id, titles: LocalizedTitles(byLanguage: {'en': title})));
      await Future<void>.delayed(const Duration(milliseconds: 1100));
    }
    await harness.collection.saveCopy(const ItemCopy(id: 'copy', itemId: 'Time Out'));
    await DriftLoanGateway(harness.database).lend('copy', borrower: 'Camille', since: DateTime(2026, 10, 1));
    Map<String, String>? written;
    final values = await HomeScreenSummary(harness.collection, DriftLoanGateway(harness.database), () async => AppLocalizationsFr(), write: (values) async => written = values).publish();
    expect(values['itemCount'], '4 objets');
    expect(values['latestAdditions'], 'Derniers ajouts : Time Out · Mingus Ah Um · Blue Train');
    expect(values['loans'], '1 prêt en cours');
    expect(written, values);
    await harness.database.close();
  });
}
