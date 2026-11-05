import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';

Future<void> deleteUnsharedImages(CollectionGateway collection, Future<void> Function(String path) deleteImage, Iterable<String> paths) async {
  final candidates = paths.toSet();
  if (candidates.isEmpty) {
    return;
  }
  final stillUsed = {for (final item in await collection.allItems()) ?item.imagePath};
  for (final path in candidates) {
    if (!stillUsed.contains(path)) {
      await deleteImage(path);
    }
  }
}
