import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:equatable/equatable.dart';

enum CategoryEditorStatus { initial, saving, saved, invalid, failed }

class SubcategoryDraft extends Equatable {
  const SubcategoryDraft({required this.name});

  final String name;
  @override
  List<Object?> get props => [name];
}

class CategoryEditorState extends Equatable {
  const CategoryEditorState({
    required this.name,
    required this.colorValue,
    required this.type,
    required this.subcategories,
    required this.conditionParts,
    required this.status,
  });

  factory CategoryEditorState.initial() => const CategoryEditorState(
        name: '',
        colorValue: 0xFF7FA8FF,
        type: CategoryType.free,
        subcategories: [],
        conditionParts: [],
        status: CategoryEditorStatus.initial,
      );

  static const List<int> categoryPalette = [
    0xFF7FA8FF,
    0xFFFF7A8A,
    0xFF6FD6B0,
    0xFF5FD3E8,
    0xFFB58CFF,
    0xFFFF9F5A,
    0xFFF2C46B,
    0xFFB7A6FF,
  ];

  final String name;
  final int colorValue;
  final CategoryType type;
  final List<SubcategoryDraft> subcategories;
  final List<String> conditionParts;
  final CategoryEditorStatus status;

  CategoryEditorState copyWith({
    String? name,
    int? colorValue,
    CategoryType? type,
    List<SubcategoryDraft>? subcategories,
    List<String>? conditionParts,
    CategoryEditorStatus? status,
  }) {
    return CategoryEditorState(
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      type: type ?? this.type,
      subcategories: subcategories ?? this.subcategories,
      conditionParts: conditionParts ?? this.conditionParts,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [name, colorValue, type, subcategories, conditionParts, status];
}
