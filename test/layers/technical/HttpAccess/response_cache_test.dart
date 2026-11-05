import 'package:akashic/layers/technical/HttpAccess/throttled_http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late List<String> sent;
  late DateTime clock;
  late int statusToAnswer;

  setUp(() {
    sent = [];
    clock = DateTime(2026, 10, 27, 10);
    statusToAnswer = 200;
  });

  ThrottledHttpClient clientFor({bool cachesPosts = false}) => ThrottledHttpClient(
        MockClient((request) async {
          sent.add('${request.method} ${request.url.path} ${request.body}');
          return http.Response('{"n":${sent.length}}', statusToAnswer);
        }),
        sourceKey: 'anilist',
        minimumInterval: Duration.zero,
        cachesPosts: cachesPosts,
        now: () => clock,
        wait: (_) async {},
      );

  test('the same read asked twice reaches the api once', () async {
    final client = clientFor();
    expect((await client.get(Uri.parse('https://example.org/a'))).body, '{"n":1}');
    expect((await client.get(Uri.parse('https://example.org/a'))).body, '{"n":1}');
    await client.get(Uri.parse('https://example.org/b'));
    expect(sent, hasLength(2));
  });

  test('identical reads asked at the same time share one call', () async {
    final client = clientFor();
    final answers = await Future.wait([for (var index = 0; index < 5; index++) client.get(Uri.parse('https://example.org/series'))]);
    expect(sent, hasLength(1));
    expect(answers.map((answer) => answer.body).toSet(), {'{"n":1}'});
  });

  test('read only queries sent by POST are kept only when the source allows it', () async {
    final plain = clientFor();
    await plain.post(Uri.parse('https://example.org/graphql'), body: 'query frieren');
    await plain.post(Uri.parse('https://example.org/graphql'), body: 'query frieren');
    expect(sent, hasLength(2));
    final graphql = clientFor(cachesPosts: true);
    await graphql.post(Uri.parse('https://example.org/graphql'), body: 'query frieren');
    await graphql.post(Uri.parse('https://example.org/graphql'), body: 'query frieren');
    await graphql.post(Uri.parse('https://example.org/graphql'), body: 'query dandadan');
    expect(sent, hasLength(4));
  });

  test('a failed answer is never kept and a kept answer expires after half an hour', () async {
    final client = clientFor();
    statusToAnswer = 503;
    await client.get(Uri.parse('https://example.org/a'));
    statusToAnswer = 200;
    await client.get(Uri.parse('https://example.org/a'));
    expect(sent, hasLength(2));
    clock = clock.add(const Duration(minutes: 29));
    await client.get(Uri.parse('https://example.org/a'));
    expect(sent, hasLength(2));
    clock = clock.add(const Duration(minutes: 2));
    await client.get(Uri.parse('https://example.org/a'));
    expect(sent, hasLength(3));
  });
}
