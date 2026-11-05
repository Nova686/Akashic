import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/presentation/source_failure_toast.dart';
import 'package:akashic/layers/technical/Feedback/error_toast_host.dart';
import 'package:akashic/layers/technical/Feedback/error_toasts.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class OpaqueFailure implements Exception {}

void main() {
  late ErrorToasts errorToasts;

  setUp(() => errorToasts = ErrorToasts());

  Future<void> host(WidgetTester tester) => tester.pumpWidget(MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => ErrorToastHost(errorToasts: errorToasts, child: child!),
        home: const Scaffold(body: Text('Ma collection')),
      ));

  testWidgets('a reported error shows a toast, once even when repeated right away', (tester) async {
    await host(tester);
    errorToasts
      ..show((l10n) => l10n.itemSaveFailedToast)
      ..show((l10n) => l10n.itemSaveFailedToast);
    await tester.pump();
    expect(find.text('L’objet n’a pas pu être enregistré.'), findsOneWidget);
  });

  testWidgets('a catalogue over its quota is named in the toast', (tester) async {
    await host(tester);
    showSourceFailure(const SourceUnavailable('discogs', 'rate limited for 60 s', true), errorToasts: errorToasts);
    await tester.pump();
    expect(find.text('Discogs : quota d’appels dépassé, réessaie plus tard.'), findsOneWidget);
  });

  testWidgets('an unexpected error shows its message, or a plain sentence when it has none', (tester) async {
    await host(tester);
    errorToasts.showUnexpected(const FormatException('réponse illisible'));
    await tester.pump();
    expect(find.textContaining('Une erreur est survenue : FormatException: réponse illisible'), findsOneWidget);
    errorToasts.showUnexpected(OpaqueFailure());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Une erreur est survenue. Réessaie.'), findsOneWidget);
  });
}
