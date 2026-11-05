import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_cubit.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_state.dart';
import 'package:akashic/layers/functional/Check/presentation/views/shelf_frames_view.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/scan_drawer.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/system_navigation_band.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChainScanView extends StatelessWidget {
  const ChainScanView({required this.cameraBuilder, required this.onSeeItem, required this.pickCategory, this.onClose, this.budgetLine, this.listenVoice, super.key});

  final Widget Function(ValueChanged<String> onBarcode, ValueChanged<Uint8List> onPhoto, ValueChanged<Uint8List>? onShelfPhoto) cameraBuilder;
  final ValueChanged<String> onSeeItem;
  final Future<Category?> Function(BuildContext context, Category? current) pickCategory;
  final VoidCallback? onClose;
  final Widget? budgetLine;
  final Future<String?> Function(BuildContext context)? listenVoice;

  String _statusLabel(ChainEntryStatus status, AppLocalizations l10n) => switch (status) {
        ChainEntryStatus.resolving => l10n.chainResolving,
        ChainEntryStatus.found => l10n.chainFound,
        ChainEntryStatus.alreadyOwned => l10n.chainAlreadyOwned,
        ChainEntryStatus.notFound => l10n.chainNotFound,
        ChainEntryStatus.unreadable => l10n.chainUnreadable,
        ChainEntryStatus.rateLimited => l10n.chainRateLimited,
        ChainEntryStatus.unreachable => l10n.chainUnreachable,
      };

  String _titleOf(ChainEntry entry) =>
      entry.match == null ? (entry.ownedTitle ?? entry.label) : (resolveDisplayTitle(entry.match!.titles, PreferredLanguages.defaults) ?? entry.label);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chain = context.read<ChainScanCubit>();
    return ScanResultAnnouncer(
      describe: (entry) => l10n.scanResultAnnouncement(_titleOf(entry), _statusLabel(entry.status, l10n)),
      child: BlocListener<ChainScanCubit, ChainScanState>(
      listenWhen: (previous, current) => current.addedCount != null && previous.addedCount != current.addedCount,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: state.failedAddCount > 0 ? AkashicColors.surface : null,
          content: Text(state.failedAddCount == 0 ? l10n.scannedItemsAdded(state.addedCount!) : l10n.scannedItemsPartlyAdded(state.addedCount!, state.failedAddCount)),
        )),
      child: ImmersiveSystemBars(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent, systemNavigationBarColor: Colors.transparent, systemNavigationBarContrastEnforced: false),
          child: Scaffold(
            backgroundColor: Colors.black,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              foregroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              flexibleSpace: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent]),
                  ),
                ),
              ),
              automaticallyImplyLeading: onClose == null,
              leading: onClose == null ? null : IconButton(tooltip: l10n.close, icon: const Icon(Icons.close), onPressed: onClose),
              actions: [
                if (listenVoice case final listen?)
                  IconButton(
                    tooltip: l10n.voiceSearch,
                    icon: const Icon(Icons.mic_none),
                    onPressed: () async {
                      final words = await listen(context);
                      if (words != null) {
                        chain.lookUpWords(words);
                      }
                    },
                  ),
              ],
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                cameraBuilder(
                  chain.scan,
                  (photo) => chain.photographCover(photo, pendingLabel: l10n.coverBeingRead),
                  chain.canPhotographShelves ? (photo) => chain.photographShelf(photo, pendingLabel: l10n.shelfBeingRead) : null,
                ),
                ScanDrawer(
                  titleOf: _titleOf,
                  statusLabel: _statusLabel,
                  onSeeItem: onSeeItem,
                  pickCategory: pickCategory,
                  budgetLine: budgetLine,
                  onOpenShelf: (photoId) => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => BlocProvider.value(value: chain, child: ShelfFramesView(photoId: photoId, titleOf: _titleOf, statusLabel: _statusLabel)),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

List<ChainEntry> settledEntriesBetween(ChainScanState previous, ChainScanState current) {
  final before = {for (final entry in previous.entries) entry.id: entry.status};
  return [
    for (final entry in current.entries)
      if (entry.status != ChainEntryStatus.resolving && before[entry.id] != entry.status && before[entry.id] != null) entry,
  ];
}


class ScanResultAnnouncer extends StatefulWidget {
  const ScanResultAnnouncer({required this.describe, required this.child, super.key});

  final String Function(ChainEntry entry) describe;
  final Widget child;

  @override
  State<ScanResultAnnouncer> createState() => _ScanResultAnnouncerState();
}

class _ScanResultAnnouncerState extends State<ScanResultAnnouncer> {
  late ChainScanState _previous = context.read<ChainScanCubit>().state;

  @override
  Widget build(BuildContext context) => BlocListener<ChainScanCubit, ChainScanState>(
        listener: (context, state) {
          final settled = settledEntriesBetween(_previous, state);
          _previous = state;
          for (final entry in settled) {
            SemanticsService.sendAnnouncement(View.of(context), widget.describe(entry), Directionality.of(context));
          }
        },
        child: widget.child,
      );
}
