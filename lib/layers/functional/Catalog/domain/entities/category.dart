import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.type,
    required this.conditionParts,
    required this.position,
    this.parentId,
  });

  final String id;
  final String? parentId;
  final String name;
  final int colorValue;
  final CategoryType type;
  final List<String> conditionParts;
  final int position;

  bool get isSubcategory => parentId != null;

  @override
  List<Object?> get props => [id, parentId, name, colorValue, type, conditionParts, position];
}

class CategoryNode extends Equatable {
  const CategoryNode({required this.category, required this.children, required this.itemCount});

  final Category category;
  final List<Category> children;
  final int itemCount;

  @override
  List<Object?> get props => [category, children, itemCount];
}
