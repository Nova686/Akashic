import 'package:akashic/layers/technical/AppShell/app_version.dart';
import 'package:akashic/layers/functional/Settings/presentation/cubit/settings_cubit.dart';
import 'package:akashic/layers/functional/Settings/presentation/cubit/settings_state.dart';
import 'package:akashic/layers/functional/Settings/presentation/views/settings_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsCubit extends MockCubit<SettingsState> implements SettingsCubit {}

void main() {
  testWidgets('the settings name each data source and carry the TMDB notice', (tester) async {
    final cubit = MockSettingsCubit();
    when(() => cubit.state).thenReturn(const SettingsState.initial());
    var importOpened = false;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<SettingsCubit>.value(value: cubit, child: SettingsView(onOpenImport: () => importOpened = true, onOpenBackup: () {})),
    ));
    await tester.scrollUntilVisible(find.textContaining('n’est ni approuvé ni certifié par TMDB'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.textContaining('Musique : Discogs'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Akashic ${AppVersion.name}'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('Akashic ${AppVersion.name}'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Importer un tableur'), -300, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Importer un tableur'));
    expect(importOpened, isTrue);
  });

  testWidgets('the language cards and chips change the languages', (tester) async {
    final cubit = MockSettingsCubit();
    when(() => cubit.state).thenReturn(const SettingsState.initial());
    when(() => cubit.chooseAppLanguage(any())).thenAnswer((_) async {});
    when(() => cubit.addLanguage(any())).thenAnswer((_) async {});
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<SettingsCubit>.value(value: cubit, child: const SettingsView()),
    ));
    await tester.tap(find.text('English'));
    verify(() => cubit.chooseAppLanguage('en')).called(1);
    await tester.tap(find.widgetWithText(ActionChip, 'Allemand'));
    verify(() => cubit.addLanguage('de')).called(1);
  });
}
