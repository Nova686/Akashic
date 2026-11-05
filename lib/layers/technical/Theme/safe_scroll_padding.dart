import 'package:flutter/widgets.dart';

EdgeInsets safeListPadding(BuildContext context, {double horizontal = 18, double top = 0, double bottom = 24}) {
  final systemBottom = MediaQuery.paddingOf(context).bottom;
  return EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom + systemBottom);
}
