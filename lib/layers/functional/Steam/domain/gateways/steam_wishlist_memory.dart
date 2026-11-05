abstract interface class SteamWishlistMemory {
  Future<Set<String>> importedAppIds();
  Future<void> rememberImported(Set<String> appIds);
}
