import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:flutter/material.dart';

class AdaptiveHomeLayout extends StatefulWidget {
  const AdaptiveHomeLayout({required this.home, required this.detail, required this.pushItem, super.key});

  static const double twoPaneWidth = 840;
  static const double listPaneWidth = 430;

  final Widget Function(ValueChanged<String> openItem) home;
  final Widget Function(String itemId) detail;
  final ValueChanged<String> pushItem;

  @override
  State<AdaptiveHomeLayout> createState() => _AdaptiveHomeLayoutState();
}

class _AdaptiveHomeLayoutState extends State<AdaptiveHomeLayout> {
  String? _selectedItemId;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < AdaptiveHomeLayout.twoPaneWidth) {
            return widget.home(widget.pushItem);
          }
          final selected = _selectedItemId;
          return Row(
            children: [
              SizedBox(width: AdaptiveHomeLayout.listPaneWidth, child: widget.home((itemId) => setState(() => _selectedItemId = itemId))),
              VerticalDivider(width: 1, thickness: 1, color: AkashicColors.line),
              Expanded(
                child: selected == null
                    ? Center(child: AkashicEmptyState(message: AppLocalizations.of(context).tabletPickAnItem))
                    : KeyedSubtree(key: ValueKey(selected), child: widget.detail(selected)),
              ),
            ],
          );
        },
      );
}
