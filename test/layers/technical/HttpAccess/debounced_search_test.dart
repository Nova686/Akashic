import 'package:akashic/layers/technical/HttpAccess/debounced_search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<String> asked;
  late List<SearchOutcome<String>> outcomes;
  late DebouncedSearch<String> search;

  setUp(() {
    asked = [];
    outcomes = [];
    search = DebouncedSearch<String>((query) async {
      asked.add(query);
      return ['$query!'];
    }, onOutcome: outcomes.add);
  });

  tearDown(() => search.close());

  testWidgets('typing quickly sends a single request once the user pauses', (tester) async {
    for (final typed in ['f', 'fr', 'fri', 'frie', 'frier', 'frieren']) {
      search.request(typed);
      await tester.pump(const Duration(milliseconds: 150));
    }
    expect(asked, isEmpty);
    await tester.pump(const Duration(milliseconds: 500));
    expect(asked, ['frieren']);
    expect(outcomes.whereType<SearchFinished<String>>().single.results, ['frieren!']);
  });

  testWidgets('fewer than three characters never reach the api', (tester) async {
    search.request('fr');
    await tester.pump(const Duration(seconds: 1));
    expect(asked, isEmpty);
    expect(outcomes.single, isA<SearchCleared<String>>());
  });

  testWidgets('the same text, or a text searched a moment ago, is not asked again', (tester) async {
    for (final typed in ['frieren', '  Frieren ', 'frieren 2', 'frieren']) {
      search.request(typed);
      await tester.pump(const Duration(seconds: 1));
    }
    expect(asked, ['frieren', 'frieren 2']);
    expect((outcomes.last as SearchFinished<String>).results, ['frieren!']);
  });

  testWidgets('a slow answer to an old query never replaces the newer one', (tester) async {
    final slow = DebouncedSearch<String>((query) async {
      await Future<void>.delayed(Duration(seconds: query == 'old query' ? 3 : 0));
      return [query];
    }, onOutcome: outcomes.add);
    slow.request('old query');
    await tester.pump(const Duration(milliseconds: 600));
    slow.request('new query');
    await tester.pump(const Duration(seconds: 5));
    expect(outcomes.whereType<SearchFinished<String>>().map((outcome) => outcome.results.single), ['new query']);
    slow.close();
  });
}
