import 'package:equatable/equatable.dart';

class SourceBlock extends Equatable {
  const SourceBlock({required this.apiFamily, required this.blockedAt, required this.retryAt});

  final String apiFamily;
  final DateTime blockedAt;
  final DateTime retryAt;

  bool isActiveAt(DateTime now) => retryAt.isAfter(now);

  Duration remainingAt(DateTime now) => isActiveAt(now) ? retryAt.difference(now) : Duration.zero;

  @override
  List<Object?> get props => [apiFamily, blockedAt, retryAt];
}
