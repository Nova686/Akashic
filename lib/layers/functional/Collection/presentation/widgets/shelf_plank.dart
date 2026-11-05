import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:flutter/material.dart';

class ShelfPlank extends StatelessWidget {
  const ShelfPlank({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF4A4290), Color(0xFF25204A)]),
        border: Border(top: BorderSide(color: AkashicColors.lavender.withValues(alpha: 0.45))),
        boxShadow: [
          const BoxShadow(color: Color(0xB3000000), offset: Offset(0, 10), blurRadius: 14, spreadRadius: -6),
          BoxShadow(color: AkashicColors.lavender.withValues(alpha: 0.35), offset: const Offset(0, -10), blurRadius: 22, spreadRadius: -10),
        ],
      ),
    );
  }
}
