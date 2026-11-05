import 'package:akashic/layers/functional/Collection/domain/use_cases/arrange_shelf.dart';
import 'package:equatable/equatable.dart';

class SmartShelf extends Equatable {
  const SmartShelf({required this.id, required this.name, required this.filter, this.categoryId});

  final String id;
  final String name;
  final String? categoryId;
  final ShelfFilter filter;

  @override
  List<Object?> get props => [id, name, categoryId, filter];
}
