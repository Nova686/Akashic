class SourceUnavailable implements Exception {
  const SourceUnavailable(this.sourceKey, [this.reason, this.isRateLimited = false]);

  final String sourceKey;
  final String? reason;
  final bool isRateLimited;

  @override
  String toString() => 'SourceUnavailable($sourceKey${reason == null ? '' : ': $reason'})';
}
