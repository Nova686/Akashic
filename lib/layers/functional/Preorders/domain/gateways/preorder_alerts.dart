abstract interface class PreorderAlerts {
  Future<void> arrivesToday(List<String> titles);
}

abstract interface class PreorderAlertMemory {
  Future<Set<String>> announced();
  Future<void> saveAnnounced(Set<String> keys);
}
