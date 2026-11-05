import 'package:equatable/equatable.dart';

const String storagePathSeparator = ' › ';

class StoragePlace extends Equatable {
  const StoragePlace({required this.id, required this.name, this.parentId, this.position = 0});

  final String id;
  final String? parentId;
  final String name;
  final int position;

  @override
  List<Object?> get props => [id, parentId, name, position];
}

class StoragePlan {
  StoragePlan(List<StoragePlace> places) : _byId = {for (final place in places) place.id: place}, _places = places;

  final Map<String, StoragePlace> _byId;
  final List<StoragePlace> _places;

  List<StoragePlace> childrenOf(String? parentId) => [for (final place in _places) if (place.parentId == parentId) place]..sort((first, second) => first.position.compareTo(second.position));

  List<StoragePlace> chainOf(String placeId) {
    final chain = <StoragePlace>[];
    var current = _byId[placeId];
    while (current != null && chain.length < 8) {
      chain.insert(0, current);
      current = current.parentId == null ? null : _byId[current.parentId];
    }
    return chain;
  }

  String pathOf(String placeId) => [for (final place in chainOf(placeId)) place.name].join(storagePathSeparator);

  List<String> descendantsOf(String placeId) => [
        for (final child in childrenOf(placeId)) ...[child.id, ...descendantsOf(child.id)],
      ];

  bool get isEmpty => _places.isEmpty;
}

bool isStoredUnder(String? location, String path) => location != null && (location == path || location.startsWith('$path$storagePathSeparator'));
