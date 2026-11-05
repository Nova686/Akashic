import 'package:flutter/material.dart';

void dropKeyboardFocus() => FocusManager.instance.primaryFocus?.unfocus();

class KeyboardFocusDropper extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => dropKeyboardFocus();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => WidgetsBinding.instance.addPostFrameCallback((_) => dropKeyboardFocus());
}

class TapOutsideClosesKeyboard extends StatelessWidget {
  const TapOutsideClosesKeyboard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(behavior: HitTestBehavior.translucent, onTap: dropKeyboardFocus, child: child);
}
