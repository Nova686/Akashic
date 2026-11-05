const int volumesUsedForEstimate = 6;

DateTime? estimateVolumeDate(Map<int, DateTime> datesByVolume, int volumeNumber) {
  final earlier = (datesByVolume.entries.where((entry) => entry.key < volumeNumber).toList()..sort((first, second) => first.key.compareTo(second.key)));
  final recent = earlier.length > volumesUsedForEstimate ? earlier.sublist(earlier.length - volumesUsedForEstimate) : earlier;
  if (recent.length < 2) {
    return null;
  }
  final first = recent.first;
  final last = recent.last;
  final daysPerVolume = last.value.difference(first.value).inDays / (last.key - first.key);
  if (daysPerVolume <= 0) {
    return null;
  }
  final estimate = last.value.add(Duration(days: (daysPerVolume * (volumeNumber - last.key)).round()));
  return DateTime(estimate.year, estimate.month);
}
