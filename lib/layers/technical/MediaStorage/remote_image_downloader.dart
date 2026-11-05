import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class RemoteImageDownloader {
  RemoteImageDownloader(this._client);

  final http.Client _client;

  Future<Uint8List?> download(String url) async {
    try {
      final response = await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 12));
      final contentType = response.headers['content-type'] ?? '';
      if (response.statusCode != 200 || response.bodyBytes.isEmpty || !(contentType.startsWith('image/') || contentType.isEmpty)) {
        return null;
      }
      return response.bodyBytes;
    } on TimeoutException {
      return null;
    } on SocketException {
      return null;
    } on http.ClientException {
      return null;
    } on FormatException {
      return null;
    }
  }
}
