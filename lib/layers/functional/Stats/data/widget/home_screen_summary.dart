import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Loans/domain/gateways/loan_gateway.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:home_widget/home_widget.dart';

typedef SummaryWriter = Future<void> Function(Map<String, String> values);

Future<void> writeToHomeWidget(Map<String, String> values) async {
  for (final MapEntry(key: key, value: value) in values.entries) {
    await HomeWidget.saveWidgetData<String>(key, value);
  }
  await HomeWidget.updateWidget(qualifiedAndroidName: 'app.akashic.akashic.AkashicWidgetProvider');
}

class HomeScreenSummary {
  HomeScreenSummary(this._collection, this._loans, this._localizations, {this._write = writeToHomeWidget, this._latestCount = 3});

  final CollectionGateway _collection;
  final LoanGateway _loans;
  final Future<AppLocalizations> Function() _localizations;
  final SummaryWriter _write;
  final int _latestCount;

  Future<Map<String, String>> publish() async {
    final l10n = await _localizations();
    final items = await _collection.allItems();
    final loans = await _loans.watchLoans().first;
    final latest = [...items.where((item) => item.addedAt != null)]..sort((first, second) => second.addedAt!.compareTo(first.addedAt!));
    final latestTitles = [
      for (final item in latest.take(_latestCount)) resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? l10n.untitled,
    ];
    final values = {
      'itemCount': l10n.widgetItemCount(items.length),
      'latestAdditions': latestTitles.isEmpty ? '' : l10n.widgetLatestAdditions(latestTitles.join(' · ')),
      'loans': loans.isEmpty ? l10n.widgetNoLoan : l10n.widgetLoans(loans.length),
    };
    await _write(values);
    return values;
  }
}
