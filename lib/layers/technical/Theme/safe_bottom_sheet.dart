import 'package:flutter/material.dart';

Future<T?> showSafeBottomSheet<T>({required BuildContext context, required WidgetBuilder builder, bool isScrollControlled = false}) => showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: true,
      builder: (sheetContext) => SafeArea(top: false, child: builder(sheetContext)),
    );
