import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:flutter/material.dart';

class DeckBox extends StatelessWidget {
  const DeckBox({required this.color, required this.size, super.key});

  final Color color;
  final SpineSize size;

  @override
  Widget build(BuildContext context) {
    final height = size == SpineSize.compact ? 52.0 : 72.0;
    return Container(
      width: height * 0.77,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          SizedBox(height: height * 0.28),
          Container(height: 1.5, color: const Color(0x59000000)),
          const Spacer(),
          Container(
            margin: EdgeInsets.fromLTRB(height * 0.17, 0, height * 0.17, height * 0.17),
            height: height * 0.33,
            decoration: BoxDecoration(color: const Color(0x38FFFFFF), borderRadius: BorderRadius.circular(3)),
          ),
        ],
      ),
    );
  }
}
