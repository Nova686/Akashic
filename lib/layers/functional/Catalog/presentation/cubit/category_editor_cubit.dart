import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/create_category.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryEditorCubit extends Cubit<CategoryEditorState> {
  CategoryEditorCubit(this._createCategory, {required this.localizePart, this.deleteCategory}) : super(CategoryEditorState.initial());

  final Future<void> Function(String categoryId)? deleteCategory;
  final CreateCategory _createCategory;
  final String Function(ConditionPartKind kind) localizePart;

  void setName(String name) => emit(state.copyWith(name: name, status: CategoryEditorStatus.initial));

  void setColor(int colorValue) => emit(state.copyWith(colorValue: colorValue));

  void selectType(CategoryType type) {
    emit(state.copyWith(type: type, conditionParts: type.defaultConditionParts.map(localizePart).toList()));
  }

  void addSubcategory(String name) {
    if (name.trim().isEmpty) {
      return;
    }
    emit(state.copyWith(subcategories: [...state.subcategories, SubcategoryDraft(name: name.trim())]));
  }

  void removeSubcategory(int index) {
    emit(state.copyWith(subcategories: [...state.subcategories]..removeAt(index)));
  }

  void addConditionPart(String part) {
    if (part.trim().isEmpty || state.conditionParts.contains(part.trim())) {
      return;
    }
    emit(state.copyWith(conditionParts: [...state.conditionParts, part.trim()]));
  }

  void removeConditionPart(int index) {
    emit(state.copyWith(conditionParts: [...state.conditionParts]..removeAt(index)));
  }

  Future<void> submit() async {
    if (state.name.trim().isEmpty) {
      emit(state.copyWith(status: CategoryEditorStatus.invalid));
      return;
    }
    emit(state.copyWith(status: CategoryEditorStatus.saving));
    final conditionParts = state.conditionParts.isEmpty
        ? state.type.defaultConditionParts.map(localizePart).toList()
        : state.conditionParts;
    final Category parent;
    try {
      parent = await _createCategory(
        name: state.name.trim(),
        colorValue: state.colorValue,
        type: state.type,
        conditionParts: conditionParts,
      );
    } on Exception {
      _fail();
      return;
    }
    try {
      for (final subcategory in state.subcategories) {
        await _createCategory(
          name: subcategory.name,
          colorValue: state.colorValue,
          type: state.type,
          parentId: parent.id,
        );
      }
    } on Exception {
      await deleteCategory?.call(parent.id);
      _fail();
      return;
    }
    if (!isClosed) {
      emit(state.copyWith(status: CategoryEditorStatus.saved));
    }
  }

  void _fail() {
    if (!isClosed) {
      emit(state.copyWith(status: CategoryEditorStatus.failed));
    }
  }
}
