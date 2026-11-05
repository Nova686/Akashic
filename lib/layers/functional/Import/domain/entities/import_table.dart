import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:equatable/equatable.dart';

class ImportTable extends Equatable {
  const ImportTable({required this.headers, required this.rows});

  final List<String> headers;
  final List<List<String>> rows;

  @override
  List<Object?> get props => [headers, rows];
}

class UnreadableSpreadsheet implements Exception {
  const UnreadableSpreadsheet();
}

enum ImportField { ignored, title, creator, barcode, edition, price, location, condition, year, series, volume }

class ImportLine extends Equatable {
  const ImportLine({
    required this.rowNumber,
    this.title,
    this.creator,
    this.barcode,
    this.edition,
    this.priceCents,
    this.location,
    this.condition,
    this.year,
    this.seriesTitle,
    this.volumeNumber,
  });

  final int rowNumber;
  final String? title;
  final String? creator;
  final String? barcode;
  final String? edition;
  final int? priceCents;
  final String? location;
  final ItemCondition? condition;
  final int? year;
  final String? seriesTitle;
  final int? volumeNumber;

  String get searchText => [?title, ?creator].join(' ');

  @override
  List<Object?> get props => [rowNumber, title, creator, barcode, edition, priceCents, location, condition, year, seriesTitle, volumeNumber];
}
