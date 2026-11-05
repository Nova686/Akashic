import 'dart:async';

import 'package:akashic/layers/technical/Feedback/error_toasts.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:flutter/material.dart';

class ErrorToastHost extends StatefulWidget {
  const ErrorToastHost({required this.child, this.errorToasts, super.key});

  final Widget child;
  final ErrorToasts? errorToasts;

  @override
  State<ErrorToastHost> createState() => _ErrorToastHostState();
}

class _ErrorToastHostState extends State<ErrorToastHost> {
  static const Duration _repeatWindow = Duration(seconds: 4);

  late final StreamSubscription<LocalizedMessage> _subscription = (widget.errorToasts ?? ErrorToasts.instance).messages.listen(_show);
  String? _lastText;
  DateTime _lastShownAt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _subscription;
  }

  void _show(LocalizedMessage message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (!mounted || messenger == null || l10n == null) {
      return;
    }
    final text = message(l10n);
    final now = DateTime.now();
    if (text == _lastText && now.difference(_lastShownAt) < _repeatWindow) {
      return;
    }
    _lastText = text;
    _lastShownAt = now;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AkashicColors.surface,
        content: Row(
          children: [
            Icon(Icons.error_outline, color: AkashicColors.missing),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: TextStyle(color: AkashicColors.text))),
          ],
        ),
      ));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
