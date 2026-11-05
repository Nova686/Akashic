import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/copy_card.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_gateway.dart';
import 'package:akashic/layers/functional/Loans/domain/entities/loan.dart';
import 'package:akashic/layers/functional/Loans/domain/use_cases/lending.dart';
import 'package:akashic/layers/functional/Loans/domain/use_cases/search_loans.dart';
import 'package:akashic/layers/functional/Loans/presentation/cubit/loans_cubit.dart';
import 'package:akashic/layers/functional/Loans/presentation/views/loans_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../Collection/collection_harness.dart';

class MockLoansCubit extends MockCubit<LoansState> implements LoansCubit {}

Widget inApp(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

void main() {
  group('lending', () {
    late CollectionHarness harness;
    late DriftLoanGateway loans;

    setUp(() async {
      harness = CollectionHarness();
      loans = DriftLoanGateway(harness.database);
      final vinyls = await harness.vinyls();
      await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})));
      await harness.collection.saveCopy(const ItemCopy(id: 'copy', itemId: 'kob', edition: '1959', conditions: {'Disque': ItemCondition.good}));
    });

    tearDown(() => harness.database.close());

    test('a lent copy appears in the loans', () async {
      expect(await LendCopy(loans, now: () => DateTime(2026, 10, 1))('copy', '  Camille '), isTrue);
      final loan = (await WatchLoans(loans)().first).single;
      expect(loan.borrower, 'Camille');
      expect(loan.since, DateTime(2026, 10, 1));
      expect(loan.itemTitles.byLanguage['en'], 'Kind of Blue');
      expect((await harness.collection.watchCopies('kob').first).single.isLent, isTrue);
    });

    test('a nameless loan is refused', () async {
      expect(await LendCopy(loans)('copy', '   '), isFalse);
      expect(await WatchLoans(loans)().first, isEmpty);
    });

    test('a returned copy leaves the loans and keeps its condition', () async {
      await LendCopy(loans)('copy', 'Camille');
      await harness.collection.saveCopy(const ItemCopy(id: 'copy', itemId: 'kob', edition: '1959 mono', conditions: {'Disque': ItemCondition.good}));
      expect((await harness.collection.watchCopies('kob').first).single.loanedTo, 'Camille');
      await ReturnCopy(loans)('copy');
      expect(await WatchLoans(loans)().first, isEmpty);
      final copy = (await harness.collection.watchCopies('kob').first).single;
      expect(copy.isLent, isFalse);
      expect(copy.conditions, {'Disque': ItemCondition.good});
    });
  });

  testWidgets('a lent copy says to whom and offers its return', (tester) async {
    var returned = false;
    await tester.pumpWidget(inApp(Scaffold(
      body: CopyCard(
        copy: ItemCopy(id: 'copy', itemId: 'kob', loanedTo: 'Camille', loanedSince: DateTime(2026, 10, 1)),
        onTap: () {},
        onLend: () {},
        onReturn: () => returned = true,
      ),
    )));
    expect(find.text('Prêté à Camille depuis le 1 oct. 2026'), findsOneWidget);
    await tester.tap(find.text('Rendu'));
    expect(returned, isTrue);
  });

  testWidgets('the loans screen lists each loan', (tester) async {
    final cubit = MockLoansCubit();
    when(() => cubit.state).thenReturn(LoansState(isLoading: false, loans: [
      Loan(copyId: 'copy', itemId: 'kob', itemTitles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), borrower: 'Camille', since: DateTime(2026, 10, 1)),
    ]));
    when(() => cubit.markReturned(any())).thenAnswer((_) async {});
    await tester.pumpWidget(inApp(BlocProvider<LoansCubit>.value(value: cubit, child: LoansView(onOpenItem: (_) {}))));
    expect(find.text('Kind of Blue'), findsOneWidget);
    await tester.tap(find.text('Rendu'));
    verify(() => cubit.markReturned('copy')).called(1);
  });

  test('a loan search matches a title, a borrower or an edition, accents and case aside', () {
    final loans = [
      Loan(copyId: 'kob', itemId: 'kob', itemTitles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), borrower: 'Camille', since: DateTime(2026, 10, 1)),
      Loan(copyId: 'frieren', itemId: 'frieren', itemTitles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'}), borrower: 'Léo', since: DateTime(2026, 9, 1), edition: 'Collector'),
    ];
    expect(searchLoans(loans, 'blue').map((loan) => loan.copyId), ['kob']);
    expect(searchLoans(loans, 'leo').map((loan) => loan.copyId), ['frieren']);
    expect(searchLoans(loans, 'COLLECTOR').map((loan) => loan.copyId), ['frieren']);
    expect(searchLoans(loans, '  '), loans);
    expect(searchLoans(loans, 'zelda'), isEmpty);
  });

  testWidgets('the loans screen filters loans with its search field', (tester) async {
    final cubit = MockLoansCubit();
    when(() => cubit.state).thenReturn(LoansState(isLoading: false, query: 'zelda', loans: [
      Loan(copyId: 'copy', itemId: 'kob', itemTitles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), borrower: 'Camille', since: DateTime(2026, 10, 1)),
    ]));
    await tester.pumpWidget(inApp(BlocProvider<LoansCubit>.value(value: cubit, child: LoansView(onOpenItem: (_) {}))));
    expect(find.text('Kind of Blue'), findsNothing);
    expect(find.text('Aucun prêt ne correspond.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'blue');
    verify(() => cubit.search('blue')).called(1);
  });
}
