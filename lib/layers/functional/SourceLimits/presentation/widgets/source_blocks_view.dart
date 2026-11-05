import 'dart:async';

import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:akashic/layers/functional/SourceLimits/domain/entities/source_block.dart';
import 'package:akashic/layers/functional/SourceLimits/domain/gateways/source_block_gateway.dart';
import 'package:akashic/layers/functional/SourceLimits/presentation/widgets/source_block_labels.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class ActiveSourceBlocks extends StatefulWidget {
  const ActiveSourceBlocks({required this.blocks, required this.builder, this.now = DateTime.now, super.key});

  final SourceBlockGateway blocks;
  final Widget Function(BuildContext context, List<SourceBlock> activeBlocks, DateTime now) builder;
  final DateTime Function() now;

  @override
  State<ActiveSourceBlocks> createState() => _ActiveSourceBlocksState();
}

class _ActiveSourceBlocksState extends State<ActiveSourceBlocks> {
  StreamSubscription<List<SourceBlock>>? _subscription;
  Timer? _ticker;
  List<SourceBlock> _blocks = const [];

  @override
  void initState() {
    super.initState();
    _subscription = widget.blocks.watchBlocks().listen((blocks) {
      if (mounted) {
        setState(() => _blocks = blocks);
        _tickWhileActive();
      }
    });
  }

  void _tickWhileActive() {
    final hasActive = _blocks.any((block) => block.isActiveAt(widget.now()));
    if (hasActive && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) {
          return;
        }
        setState(() {});
        if (!_blocks.any((block) => block.isActiveAt(widget.now()))) {
          _ticker?.cancel();
          _ticker = null;
        }
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = widget.now();
    return widget.builder(context, [for (final block in _blocks) if (block.isActiveAt(now)) block], now);
  }
}

class SourceBlocksBanner extends StatelessWidget {
  const SourceBlocksBanner({required this.blocks, this.now = DateTime.now, super.key});

  final SourceBlockGateway blocks;
  final DateTime Function() now;

  void _showDetails(BuildContext context) {
    showSafeBottomSheet<void>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
        child: SourceBlocksList(blocks: blocks, now: now),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ActiveSourceBlocks(
      blocks: blocks,
      now: now,
      builder: (context, active, current) {
        if (active.isEmpty) {
          return const SizedBox.shrink();
        }
        final soonest = active.reduce((first, second) => first.retryAt.isBefore(second.retryAt) ? first : second);
        final remaining = formatRemaining(soonest.remainingAt(current));
        return Material(
          color: AkashicColors.surface,
          child: InkWell(
            onTap: () => _showDetails(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.hourglass_bottom, size: 16, color: AkashicColors.teal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      active.length == 1 ? l10n.apiPausedCountdown(apiDisplayName(soonest.apiFamily), remaining) : l10n.apiPausedSeveral(active.length, remaining),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: AkashicColors.teal),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SourceBlocksList extends StatelessWidget {
  const SourceBlocksList({required this.blocks, this.now = DateTime.now, super.key});

  final SourceBlockGateway blocks;
  final DateTime Function() now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ActiveSourceBlocks(
      blocks: blocks,
      now: now,
      builder: (context, active, current) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.apiLimitsExplanation, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
          const SizedBox(height: 8),
          if (active.isEmpty) Text(l10n.noApiPaused, style: AkashicTypography.body(size: 13)),
          for (final block in active)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.hourglass_bottom, color: AkashicColors.teal),
              title: Text(apiDisplayName(block.apiFamily), style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
              subtitle: Text(
                l10n.apiBlockedAtRetryAt(formatClock(l10n, block.blockedAt, current), formatClock(l10n, block.retryAt, current)),
                style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft),
              ),
              trailing: Text(formatRemaining(block.remainingAt(current)), style: AkashicTypography.numeral(size: 15).copyWith(color: AkashicColors.teal)),
            ),
        ],
      ),
    );
  }
}
