import 'package:equatable/equatable.dart';

class SealedProduct extends Equatable {
  const SealedProduct({required this.id, required this.name, required this.categoryName, this.addedAt});

  final String id;
  final String name;
  final String categoryName;
  final DateTime? addedAt;

  @override
  List<Object?> get props => [id, name, categoryName, addedAt];
}
