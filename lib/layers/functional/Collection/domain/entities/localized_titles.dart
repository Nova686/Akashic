import 'package:equatable/equatable.dart';

class LocalizedTitles extends Equatable {
  const LocalizedTitles({required this.byLanguage, this.originalLanguage});

  final Map<String, String> byLanguage;
  final String? originalLanguage;

  @override
  List<Object?> get props => [byLanguage, originalLanguage];
}
