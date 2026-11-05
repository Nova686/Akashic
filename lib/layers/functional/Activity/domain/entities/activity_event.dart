import 'package:equatable/equatable.dart';

enum ActivityKind { added, started, finished, sold, lent, returned, valueRose, valueFell, merged, received }

class ActivityEvent extends Equatable {
  const ActivityEvent({required this.kind, required this.title, required this.at, this.itemId, this.categoryId, this.amountCents, this.currency, this.detail});

  final ActivityKind kind;
  final String title;
  final DateTime at;
  final String? itemId;
  final String? categoryId;
  final int? amountCents;
  final String? currency;
  final String? detail;

  @override
  List<Object?> get props => [kind, title, at, itemId, categoryId, amountCents, currency, detail];
}
