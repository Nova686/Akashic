import 'package:equatable/equatable.dart';

class ItemPhoto extends Equatable {
  const ItemPhoto({required this.id, required this.itemId, required this.path, required this.position, this.copyId});

  final String id;
  final String itemId;
  final String? copyId;
  final String path;
  final int position;

  @override
  List<Object?> get props => [id, itemId, copyId, path, position];
}
