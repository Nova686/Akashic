import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/missing_volume_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_divider_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_row.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  testWidgets('a very long divider label is ellipsized without overflow', (tester) async {
    await tester.pumpWidget(host(SizedBox(
      width: 18,
      height: 84,
      child: ShelfDividerView(label: 'Art Blakey & The Jazz Messengers', size: SpineSize.large, onTap: () {}),
    )));
    expect(tester.takeException(), isNull);
    final paragraph = tester.renderObject<RenderParagraph>(find.text('ART BLAKEY & THE JAZZ MESSENGERS'));
    expect(paragraph.didExceedMaxLines, isTrue);
  });

  testWidgets('light spines use dark text', (tester) async {
    const item = CollectionItem(id: 'wall', categoryId: 'rock', titles: LocalizedTitles(byLanguage: {'en': 'The Wall'}), spineColorValue: 0xFFEFEFEF);
    await tester.pumpWidget(host(const ItemSpine(item: item, label: 'The Wall', shape: SpineShape.flat, size: SpineSize.large, fallbackColorValue: 0xFF7FA8FF)));
    final text = tester.widget<Text>(find.text('The Wall'));
    expect(text.style?.color, AkashicColors.night);
  });

  testWidgets('dark spines use light text and fall back to the category color', (tester) async {
    const item = CollectionItem(id: 'kob', categoryId: 'jazz', titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}));
    await tester.pumpWidget(host(const ItemSpine(item: item, label: 'Kind of Blue', shape: SpineShape.flat, size: SpineSize.large, fallbackColorValue: 0xFF20304A)));
    final text = tester.widget<Text>(find.text('Kind of Blue'));
    expect(text.style?.color, Colors.white);
  });

  testWidgets('missing volume shows its number in the numeral face', (tester) async {
    await tester.pumpWidget(host(const MissingVolumeSpine(volumeNumber: 4, size: SpineSize.large)));
    final text = tester.widget<Text>(find.text('4'));
    expect(text.style?.fontFamily, AkashicTypography.numeral().fontFamily);
  });

  testWidgets('the home shelf shows no labelled divider and a collapsed series shows one block', (tester) async {
    final toggled = <String>[];
    const volume = CollectionItem(id: 'f1', categoryId: 'mangas', seriesId: 'frieren', volumeNumber: 1, titles: LocalizedTitles(byLanguage: {'fr': 'Frieren'}));
    const group = ShelfGroup(
      id: 'frieren',
      label: 'Frieren',
      isSeries: true,
      ownedCount: 1,
      entries: [ShelfDivider(label: 'Frieren', groupId: 'frieren'), ShelfItem(volume), ShelfMissingVolume(seriesId: 'frieren', volumeNumber: 2)],
    );
    Widget rowWith(Set<String> collapsed) => host(SizedBox(
          width: 320,
          child: ShelfRow(
            groups: const [group],
            type: CategoryType.manga,
            size: SpineSize.large,
            categoryColorValue: 0xFFFF7A8A,
            collapsedSeriesIds: collapsed,
            onToggleSeries: toggled.add,
            onOpenItem: (_) {},
          ),
        ));
    await tester.pumpWidget(rowWith(const {}));
    expect(find.text('FRIEREN'), findsNothing);
    expect(find.byType(MissingVolumeSpine), findsOneWidget);
    await tester.pumpWidget(rowWith(const {'frieren'}));
    expect(find.text('1'), findsOneWidget);
    expect(find.byType(MissingVolumeSpine), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
