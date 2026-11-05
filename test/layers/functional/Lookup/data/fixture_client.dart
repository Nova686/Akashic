import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

String fixture(String name) => File('test/fixtures/sources/$name').readAsStringSync();

MockClient clientReturning(String body, {List<http.Request>? requests}) {
  return MockClient((request) async {
    requests?.add(request);
    return http.Response.bytes(utf8.encode(body), 200, headers: {'content-type': 'application/json; charset=utf-8'});
  });
}
