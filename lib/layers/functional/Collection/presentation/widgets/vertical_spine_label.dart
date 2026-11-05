import 'package:flutter/material.dart';

class VerticalSpineLabel extends StatelessWidget {
  const VerticalSpineLabel({required this.text, required this.style, super.key});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(text, maxLines: 1, softWrap: false, overflow: TextOverflow.ellipsis, style: style),
      ),
    );
  }
}
