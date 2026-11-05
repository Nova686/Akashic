import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:akashic/layers/technical/HttpAccess/json_http.dart';
import 'package:akashic/layers/technical/HttpAccess/rate_limits.dart';
import 'package:http/http.dart' as http;

class ThrottledHttpClient extends http.BaseClient {
  ThrottledHttpClient(
    this._inner, {
    required this.sourceKey,
    required this._minimumInterval,
    this._defaultHeaders = const {},
    this._timeout = const Duration(seconds: 8),
    this._rateLimits,
    this._cacheDuration = const Duration(minutes: 30),
    this._cachesPosts = false,
    DateTime Function()? now,
    Future<void> Function(Duration duration)? wait,
  })  : _now = now ?? DateTime.now,
        _wait = wait ?? Future<void>.delayed;

  final http.Client _inner;
  final String sourceKey;
  final Duration _minimumInterval;
  final Map<String, String> _defaultHeaders;
  final Duration _timeout;
  final RateLimitRecorder? _rateLimits;
  final Duration _cacheDuration;
  final bool _cachesPosts;
  final Map<String, _RememberedResponse> _remembered = {};
  final Map<String, Future<_RememberedResponse>> _inFlight = {};
  static const int _rememberedLimit = 150;
  final DateTime Function() _now;
  final Future<void> Function(Duration duration) _wait;
  Future<void> _queue = Future<void>.value();
  DateTime? _lastStart;

  String get _apiFamily => apiFamilyOf(sourceKey);

  String? _cacheKeyOf(http.BaseRequest request) {
    if (_cacheDuration == Duration.zero) {
      return null;
    }
    if (request.method == 'GET') {
      return 'GET ${request.url}';
    }
    if (request.method == 'POST' && _cachesPosts && request is http.Request) {
      return 'POST ${request.url} ${request.body}';
    }
    return null;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final blockedUntil = _rateLimits?.blockedUntil(_apiFamily);
    if (blockedUntil != null && blockedUntil.isAfter(_now())) {
      return _refusedLocally(request, blockedUntil);
    }
    final key = _cacheKeyOf(request);
    if (key == null) {
      return _sendInTurn(request);
    }
    final remembered = _remembered[key];
    if (remembered != null && remembered.expiresAt.isAfter(_now())) {
      return remembered.toResponse(request);
    }
    final pending = _inFlight[key] ??= _fetchAndRemember(request, key).whenComplete(() {
      _inFlight.remove(key);
    });
    return (await pending).toResponse(request);
  }

  Future<_RememberedResponse> _fetchAndRemember(http.BaseRequest request, String key) async {
    final response = await _sendInTurn(request);
    final List<int> bytes;
    try {
      bytes = await response.stream.toBytes().timeout(_timeout);
    } on TimeoutException {
      throw RemoteServiceUnavailable(sourceKey, 'timeout');
    }
    final answer = _RememberedResponse(statusCode: response.statusCode, headers: response.headers, body: bytes, expiresAt: _now().add(_cacheDuration));
    final isWorthKeeping = (response.statusCode >= 200 && response.statusCode < 300) || response.statusCode == 404;
    if (isWorthKeeping) {
      _remembered.remove(key);
      _remembered[key] = answer;
      while (_remembered.length > _rememberedLimit) {
        _remembered.remove(_remembered.keys.first);
      }
    }
    return answer;
  }

  Future<http.StreamedResponse> _sendInTurn(http.BaseRequest request) {
    final turn = _queue.then((_) => _waitForTurn());
    _queue = turn.catchError((Object _) {});
    return turn.then((_) => _sendNow(request));
  }

  Future<void> _waitForTurn() async {
    final lastStart = _lastStart;
    if (lastStart != null) {
      final elapsed = _now().difference(lastStart);
      if (elapsed < _minimumInterval) {
        await _wait(_minimumInterval - elapsed);
      }
    }
    _lastStart = _now();
  }

  Future<http.StreamedResponse> _sendNow(http.BaseRequest request) async {
    for (final MapEntry(key: name, value: value) in _defaultHeaders.entries) {
      request.headers.putIfAbsent(name, () => value);
    }
    try {
      final response = await _inner.send(request).timeout(_timeout);
      return response.statusCode == 429 ? await _recordLimit(request, response) : response;
    } on TimeoutException {
      throw RemoteServiceUnavailable(sourceKey, 'timeout');
    } on IOException catch (error) {
      throw RemoteServiceUnavailable(sourceKey, '$error');
    } on http.ClientException catch (error) {
      throw RemoteServiceUnavailable(sourceKey, error.message);
    }
  }

  http.StreamedResponse _refusedLocally(http.BaseRequest request, DateTime blockedUntil) {
    final seconds = blockedUntil.difference(_now()).inSeconds + 1;
    return http.StreamedResponse(const Stream.empty(), 429, request: request, headers: {'retry-after': '$seconds', blockedLocallyHeader: 'true'});
  }

  Future<http.StreamedResponse> _recordLimit(http.BaseRequest request, http.StreamedResponse response) async {
    final bytes = await response.stream.toBytes();
    final blockedAt = _now();
    final retryAt = retryAtFor(apiFamily: _apiFamily, headers: response.headers, body: utf8.decode(bytes, allowMalformed: true), now: blockedAt);
    await _rateLimits?.recordBlock(_apiFamily, blockedAt: blockedAt, retryAt: retryAt);
    return http.StreamedResponse(
      Stream.value(bytes),
      429,
      request: request,
      headers: {...response.headers, 'retry-after': '${retryAt.difference(blockedAt).inSeconds}'},
      reasonPhrase: response.reasonPhrase,
    );
  }

  @override
  void close() => _inner.close();
}

class _RememberedResponse {
  const _RememberedResponse({required this.statusCode, required this.headers, required this.body, required this.expiresAt});

  final int statusCode;
  final Map<String, String> headers;
  final List<int> body;
  final DateTime expiresAt;

  http.StreamedResponse toResponse(http.BaseRequest request) =>
      http.StreamedResponse(Stream.value(body), statusCode, request: request, headers: headers, contentLength: body.length);
}
