import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/item_detail_view.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockItemDetailCubit extends MockCubit<ItemDetailState> implements ItemDetailCubit {}

void main() {
  testWidgets('the learn more tab shows the details, the fetch date and the update button', (tester) async {
    final cubit = MockItemDetailCubit();
    when(() => cubit.canManagePhotos).thenReturn(false);
    when(() => cubit.state).thenReturn(ItemDetailState(
      item: const CollectionItem(id: 'kob', categoryId: 'jazz', titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})),
      category: const Category(id: 'jazz', name: 'Jazz', colorValue: 0, type: CategoryType.music, conditionParts: [], position: 0),
      isLoading: false,
      canFetchDetails: true,
      details: ItemDetails(
        fetchedAt: DateTime(2026, 9, 12),
        sections: const [
          TrackListSection(tracks: [DetailTrack(position: 'A1', title: 'So What', duration: '9:22')], sourceLabel: 'MusicBrainz'),
          TagSection(tags: ['cool jazz']),
        ],
      ),
    ));
    when(() => cubit.refreshDetails(any())).thenAnswer((_) async {});
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ItemDetailCubit>.value(value: cubit, child: ItemDetailView(onEditCopy: (copy, parts) {})),
    ));
    await tester.tap(find.text('En savoir plus'));
    await tester.pumpAndSettle();
    expect(find.text('So What'), findsOneWidget);
    expect(find.text('cool jazz'), findsOneWidget);
    expect(find.textContaining('12 sept. 2026'), findsOneWidget);
    await tester.tap(find.text('Mettre à jour'));
    verify(() => cubit.refreshDetails('fr')).called(1);
  });
}
