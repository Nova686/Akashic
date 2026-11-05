import 'package:equatable/equatable.dart';

enum ScanSource { barcode, cover, shelf }

enum ScanOutcome { added, owned, missed }

class ScanSessionEntry extends Equatable {
  const ScanSessionEntry({required this.title, required this.outcome, required this.source, this.itemId});

  final String title;
  final ScanOutcome outcome;
  final ScanSource source;
  final String? itemId;

  @override
  List<Object?> get props => [title, outcome, source, itemId];
}

class ScanSession extends Equatable {
  const ScanSession({required this.id, required this.startedAt, required this.mode, required this.entries});

  final String id;
  final DateTime startedAt;
  final ScanSource mode;
  final List<ScanSessionEntry> entries;

  int countOf(ScanOutcome outcome) => entries.where((entry) => entry.outcome == outcome).length;

  List<ScanSessionEntry> entriesWith(ScanOutcome outcome) => [for (final entry in entries) if (entry.outcome == outcome) entry];

  @override
  List<Object?> get props => [id, startedAt, mode, entries];
}

ScanSource dominantSourceOf(List<ScanSessionEntry> entries) {
  final counts = {for (final source in ScanSource.values) source: entries.where((entry) => entry.source == source).length};
  return ScanSource.values.reduce((best, source) => counts[source]! > counts[best]! ? source : best);
}
