import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_plank.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class EmptyShelfLine extends StatelessWidget {
  const EmptyShelfLine({required this.message, this.actionLabel, this.onAction, super.key});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 4, 0, 4),
          child: Row(
            children: [
              Expanded(child: Text(message, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft))),
              if ((actionLabel, onAction) case (final label?, final action?))
                TextButton.icon(onPressed: action, icon: const Icon(Icons.add, size: 18), label: Text(label)),
            ],
          ),
        ),
        const ShelfPlank(),
      ],
    );
  }
}
