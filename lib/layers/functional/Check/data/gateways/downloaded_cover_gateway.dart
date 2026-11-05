import 'dart:typed_data';

import 'package:akashic/layers/functional/Check/domain/gateways/cover_image_gateway.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/remote_image_downloader.dart';

class DownloadedCoverGateway implements CoverImageGateway {
  DownloadedCoverGateway(this._downloader, this._imageStore, {required this._extractColor});

  final RemoteImageDownloader _downloader;
  final LocalImageStore _imageStore;
  final Future<int> Function(Uint8List bytes) _extractColor;

  @override
  Future<StoredCover?> storeCover(String url) async {
    final bytes = await _downloader.download(url);
    if (bytes == null) {
      return null;
    }
    final path = await _imageStore.save(bytes);
    try {
      return StoredCover(path: path, spineColorValue: await _extractColor(bytes));
    } on FormatException {
      return StoredCover(path: path);
    }
  }
}
