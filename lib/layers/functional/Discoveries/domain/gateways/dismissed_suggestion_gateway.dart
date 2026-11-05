abstract interface class DismissedSuggestionGateway {
  Future<Set<String>> identities();
  Future<void> dismiss(Set<String> identities);
}
