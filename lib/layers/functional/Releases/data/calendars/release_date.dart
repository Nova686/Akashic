import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';

final RegExp _datePrefix = RegExp(r'^(\d{4})(?:[-/](\d{1,2})(?:[-/](\d{1,2}))?)?');

({DateTime date, ReleaseDatePrecision precision})? releaseDateOf(Object? value) {
  final match = _datePrefix.firstMatch(textOf(value) ?? '');
  if (match == null) {
    return null;
  }
  final year = int.parse(match.group(1)!);
  final month = match.group(2);
  final day = match.group(3);
  return (
    date: DateTime(year, int.parse(month ?? '1'), int.parse(day ?? '1')),
    precision: day != null
        ? ReleaseDatePrecision.day
        : month != null
            ? ReleaseDatePrecision.month
            : ReleaseDatePrecision.year,
  );
}
