import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:uuid/uuid.dart';

class CategoryDepthExceeded implements Exception {
  const CategoryDepthExceeded();
}

class ParentCategoryNotFound implements Exception {
  const ParentCategoryNotFound(this.parentId);

  final String parentId;
}

class CreateCategory {
  CreateCategory(this._gateway, {String Function()? newId}) : _newId = newId ?? const Uuid().v4;

  final CategoryGateway _gateway;
  final String Function() _newId;

  Future<Category> call({
    required String name,
    required int colorValue,
    required CategoryType type,
    String? parentId,
    List<String>? conditionParts,
  }) async {
    final parent = parentId == null ? null : await _gateway.findById(parentId);
    if (parentId != null && parent == null) {
      throw ParentCategoryNotFound(parentId);
    }
    if (parent != null && parent.isSubcategory) {
      throw const CategoryDepthExceeded();
    }
    final category = Category(
      id: _newId(),
      parentId: parentId,
      name: name.trim(),
      colorValue: colorValue,
      type: parent?.type ?? type,
      conditionParts: conditionParts ?? parent?.conditionParts ?? const [],
      position: await _gateway.countChildrenOf(parentId),
    );
    await _gateway.save(category);
    return category;
  }
}
