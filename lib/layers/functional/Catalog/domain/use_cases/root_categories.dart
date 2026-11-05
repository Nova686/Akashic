import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';

Map<String, Category> rootCategoryById(List<CategoryNode> tree) => {
      for (final node in tree) ...{
        node.category.id: node.category,
        for (final child in node.children) child.id: node.category,
      },
    };
