import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:akashic/layers/functional/Import/presentation/cubit/import_cubit.dart';
import 'package:akashic/layers/functional/Import/presentation/cubit/import_state.dart';
import 'package:akashic/layers/functional/Import/presentation/views/import_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/MediaStorage/spreadsheet_files.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockImportCubit extends MockCubit<ImportState> implements ImportCubit {}

class MockSpreadsheetFiles extends Mock implements SpreadsheetFiles {}

void main() {
  testWidgets('the column step shows each header with a sample and the rows to import', (tester) async {
    final cubit = MockImportCubit();
    when(() => cubit.state).thenReturn(const ImportState(
      step: ImportStep.mapColumns,
      categoryId: 'jazz',
      table: ImportTable(headers: ['Titre', 'Remarque'], rows: [
        ['Kind of Blue', 'cadeau'],
        ['Blue Train', ''],
      ]),
      mapping: {0: ImportField.title, 1: ImportField.ignored},
    ));
    when(() => cubit.startReview()).thenAnswer((_) async {});
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ImportCubit>.value(value: cubit, child: ImportView(categories: const [], files: MockSpreadsheetFiles())),
    ));
    expect(find.text('Kind of Blue'), findsOneWidget);
    expect(find.text('Ignorer'), findsOneWidget);
    await tester.tap(find.text('Continuer avec 2 lignes'));
    verify(() => cubit.startReview()).called(1);
  });

  test('the template lists every importable field in the app language', () {
    final template = String.fromCharCodes(importTemplate(lookupAppLocalizations(const Locale('fr'))));
    expect(template, contains('Titre;Artiste ou auteur;Code-barres'));
  });
}
