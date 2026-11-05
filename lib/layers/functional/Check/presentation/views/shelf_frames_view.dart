import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_cubit.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_state.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/scan_entry_cover.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

IconData frameStatusIcon(ChainEntryStatus status) => switch (status) {
      ChainEntryStatus.found => Icons.add,
      ChainEntryStatus.alreadyOwned => Icons.check,
      ChainEntryStatus.resolving => Icons.hourglass_empty,
      _ => Icons.question_mark,
    };

class ShelfFramesView extends StatefulWidget {
  const ShelfFramesView({required this.photoId, required this.titleOf, required this.statusLabel, super.key});

  final String photoId;
  final String Function(ChainEntry entry) titleOf;
  final String Function(ChainEntryStatus status, AppLocalizations l10n) statusLabel;

  @override
  State<ShelfFramesView> createState() => _ShelfFramesViewState();
}

class _ShelfFramesViewState extends State<ShelfFramesView> {
  String? _selectedEntryId;
  final Map<String, GlobalKey> _rowKeys = {};

  void _select(String entryId, {bool reveal = false}) {
    setState(() => _selectedEntryId = entryId);
    if (reveal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_rowKeys[entryId]?.currentContext case final rowContext?) {
          Scrollable.ensureVisible(rowContext, duration: const Duration(milliseconds: 240), alignment: 0.3);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chain = context.read<ChainScanCubit>();
    final photo = chain.shelfPhoto(widget.photoId);
    return BlocBuilder<ChainScanCubit, ChainScanState>(
      builder: (context, state) {
        final framed = [for (final entry in state.entries) if (entry.shelfPhotoId == widget.photoId && entry.spineBounds != null) entry];
        return Scaffold(
          appBar: AppBar(title: Text(l10n.shelfRead, style: AkashicTypography.displayTitle(size: 26))),
          body: photo == null
              ? Center(child: Text(l10n.shelfPhotoGone, style: AkashicTypography.body().copyWith(color: AkashicColors.textSoft)))
              : ListView(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 96 + MediaQuery.paddingOf(context).bottom),
                  children: [
                    const _FrameLegend(),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.5),
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: photo.width / photo.height,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: LayoutBuilder(
                              builder: (context, constraints) => Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.memory(photo.bytes, fit: BoxFit.fill, gaplessPlayback: true),
                                  for (final (index, entry) in framed.indexed)
                                    _SpineFrame(
                                      number: index + 1,
                                      entry: entry,
                                      area: constraints.biggest,
                                      isSelected: entry.id == _selectedEntryId,
                                      label: '${index + 1}. ${widget.titleOf(entry)}, ${widget.statusLabel(entry.status, l10n)}',
                                      onTap: () => _select(entry.id, reveal: true),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.tapFrameToFindLine, textAlign: TextAlign.center, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                    const SizedBox(height: 8),
                    for (final (index, entry) in framed.indexed)
                      _FramedEntryRow(
                        key: _rowKeys.putIfAbsent(entry.id, GlobalKey.new),
                        number: index + 1,
                        entry: entry,
                        title: widget.titleOf(entry),
                        status: widget.statusLabel(entry.status, l10n),
                        isSelected: entry.id == _selectedEntryId,
                        onTap: () => _select(entry.id),
                        onToggle: () => chain.toggle(state.entries.indexOf(entry)),
                      ),
                  ],
                ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: FilledButton(
              onPressed: state.acceptedCount == 0 || state.isCommitting ? null : chain.commit,
              child: Text(l10n.addScannedItems(state.acceptedCount)),
            ),
          ),
        );
      },
    );
  }
}

class _FrameLegend extends StatelessWidget {
  const _FrameLegend();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        for (final (label, color, icon) in [
          (l10n.chainFound, AkashicColors.teal, frameStatusIcon(ChainEntryStatus.found)),
          (l10n.chainAlreadyOwned, AkashicColors.lavender, frameStatusIcon(ChainEntryStatus.alreadyOwned)),
          (l10n.chainNotFound, AkashicColors.gold, frameStatusIcon(ChainEntryStatus.notFound)),
          (l10n.chainResolving, AkashicColors.textFaint, frameStatusIcon(ChainEntryStatus.resolving)),
        ])
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                child: Icon(icon, size: 12, color: AkashicColors.night),
              ),
              const SizedBox(width: 6),
              Text(label, style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: AkashicColors.textSoft)),
            ],
          ),
      ],
    );
  }
}

class _SpineFrame extends StatelessWidget {
  const _SpineFrame({required this.number, required this.entry, required this.area, required this.isSelected, required this.label, required this.onTap});

  final int number;
  final ChainEntry entry;
  final Size area;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bounds = entry.spineBounds!;
    final color = scanStatusColor(entry);
    final isResolving = entry.status == ChainEntryStatus.resolving;
    return Positioned(
      left: bounds.left * area.width,
      top: bounds.top * area.height,
      width: ((bounds.right - bounds.left) * area.width).clamp(18, area.width),
      height: ((bounds.bottom - bounds.top) * area.height).clamp(18, area.height),
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        onTap: onTap,
        excludeSemantics: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: CustomPaint(
            painter: _FramePainter(color: color, isDashed: isResolving, width: isSelected ? 4 : 2.5, fill: isSelected ? color.withValues(alpha: 0.22) : null),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(frameStatusIcon(entry.status), size: 11, color: AkashicColors.night),
                    const SizedBox(width: 2),
                    Text('$number', style: AkashicTypography.numeral(size: 12).copyWith(color: AkashicColors.night, height: 1.2)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  const _FramePainter({required this.color, required this.isDashed, required this.width, this.fill});

  final Color color;
  final bool isDashed;
  final double width;
  final Color? fill;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(6)).deflate(width / 2);
    if (fill case final fillColor?) {
      canvas.drawRRect(rect, Paint()..color = fillColor);
    }
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    if (!isDashed) {
      canvas.drawRRect(rect, stroke);
      return;
    }
    for (final metric in (Path()..addRRect(rect)).computeMetrics()) {
      for (var distance = 0.0; distance < metric.length; distance += 10) {
        canvas.drawPath(metric.extractPath(distance, distance + 5), stroke);
      }
    }
  }

  @override
  bool shouldRepaint(_FramePainter oldDelegate) => oldDelegate.color != color || oldDelegate.isDashed != isDashed || oldDelegate.width != width || oldDelegate.fill != fill;
}

class _FramedEntryRow extends StatelessWidget {
  const _FramedEntryRow({required this.number, required this.entry, required this.title, required this.status, required this.isSelected, required this.onTap, required this.onToggle, super.key});

  final int number;
  final ChainEntry entry;
  final String title;
  final String status;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = scanStatusColor(entry);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.16) : AkashicColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isSelected ? color : Colors.transparent, width: 2),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
        onTap: onTap,
        selected: isSelected,
        leading: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
          child: Text('$number', style: AkashicTypography.numeral(size: 14).copyWith(color: AkashicColors.night)),
        ),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
        subtitle: Text(status, style: AkashicTypography.body(size: 12).copyWith(color: entry.status == ChainEntryStatus.found ? AkashicColors.textSoft : color)),
        trailing: entry.status == ChainEntryStatus.found ? Checkbox(value: entry.isAccepted && entry.canBeAdded, onChanged: entry.canBeAdded ? (_) => onToggle() : null) : null,
        ),
      ),
    );
  }
}
