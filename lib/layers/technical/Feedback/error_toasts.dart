import 'dart:async';

import 'package:akashic/layers/technical/Localization/app_localizations.dart';

typedef LocalizedMessage = String Function(AppLocalizations l10n);

class ErrorToasts {
  ErrorToasts();

  static final ErrorToasts instance = ErrorToasts();

  static const int _maximumDetailLength = 140;

  final StreamController<LocalizedMessage> _messages = StreamController<LocalizedMessage>.broadcast();

  Stream<LocalizedMessage> get messages => _messages.stream;

  void show(LocalizedMessage message) => _messages.add(message);

  void showUnexpected(Object error) => show((l10n) => describeUnexpectedError(error, l10n));

  static String describeUnexpectedError(Object error, AppLocalizations l10n) {
    final detail = '$error'.trim();
    if (detail.isEmpty || detail.startsWith('Instance of')) {
      return l10n.unexpectedError;
    }
    final shortened = detail.length > _maximumDetailLength ? '${detail.substring(0, _maximumDetailLength)}…' : detail;
    return l10n.unexpectedErrorWithDetail(shortened);
  }
}
