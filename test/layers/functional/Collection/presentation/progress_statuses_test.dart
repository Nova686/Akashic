import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/progress_section.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_header.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('each category type offers the progress that makes sense for it, with its own words', () {
    final l10n = lookupAppLocalizations(const Locale('fr'));
    List<String> labelsOf(CategoryType type) => [for (final status in progressStatusesFor(type)) progressStatusLabel(status, type, l10n)];
    expect(labelsOf(CategoryType.manga), ['À lire', 'En cours', 'Lu', 'Abandonné']);
    expect(labelsOf(CategoryType.films), ['À voir', 'En cours', 'Vu', 'Abandonné']);
    expect(labelsOf(CategoryType.videoGames), ['À jouer', 'En cours', 'Terminé', 'Abandonné']);
    expect(labelsOf(CategoryType.boardGames), ['À jouer', 'Joué']);
    expect(labelsOf(CategoryType.music), ['À écouter', 'Écouté']);
    expect(labelsOf(CategoryType.lego), ['À monter', 'En montage', 'Monté']);
    expect(labelsOf(CategoryType.free), ['Pas commencé', 'En cours', 'Fini', 'Abandonné']);
    for (final type in [CategoryType.cards, CategoryType.amiibo, CategoryType.consoles]) {
      expect(tracksProgress(type), isFalse, reason: type.name);
    }
  });

  testWidgets('the count and the arrow of a shelf header sit on the right edge', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SizedBox(width: 360, child: ShelfHeader(name: 'TCG', colorValue: 0xFF7FA8FF, itemCount: 4, onTap: () {}))),
    ));
    expect(tester.getRect(find.byIcon(Icons.chevron_right)).right, closeTo(360, 1));
    expect(tester.getRect(find.text('4')).left, greaterThan(300));
  });
}
