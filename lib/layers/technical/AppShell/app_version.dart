abstract final class AppVersion {
  static const String name = String.fromEnvironment('APP_VERSION_NAME', defaultValue: '1.45.0');

  static String get label => name;
}
