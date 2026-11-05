import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

List<ProgressStatus> progressStatusesFor(CategoryType? type) => switch (type) {
      CategoryType.cards || CategoryType.amiibo || CategoryType.consoles => const [],
      CategoryType.music || CategoryType.boardGames => const [ProgressStatus.notStarted, ProgressStatus.finished],
      CategoryType.lego => const [ProgressStatus.notStarted, ProgressStatus.inProgress, ProgressStatus.finished],
      _ => ProgressStatus.values,
    };

bool tracksProgress(CategoryType? type) => progressStatusesFor(type).isNotEmpty;

bool tracksReadingPlace(CategoryType? type) => const {CategoryType.books, CategoryType.manga, CategoryType.comics}.contains(type);

String progressStatusLabel(ProgressStatus status, CategoryType? type, AppLocalizations l10n) => switch ((status, type)) {
      (ProgressStatus.notStarted, CategoryType.books || CategoryType.manga || CategoryType.comics) => l10n.progressToRead,
      (ProgressStatus.notStarted, CategoryType.videoGames || CategoryType.boardGames) => l10n.progressToPlay,
      (ProgressStatus.notStarted, CategoryType.films) => l10n.progressToWatch,
      (ProgressStatus.notStarted, CategoryType.music) => l10n.progressToListen,
      (ProgressStatus.notStarted, CategoryType.lego) => l10n.progressToBuild,
      (ProgressStatus.notStarted, _) => l10n.progressNotStarted,
      (ProgressStatus.inProgress, CategoryType.lego) => l10n.progressBuilding,
      (ProgressStatus.inProgress, _) => l10n.progressInProgress,
      (ProgressStatus.finished, CategoryType.books || CategoryType.manga || CategoryType.comics) => l10n.progressRead,
      (ProgressStatus.finished, CategoryType.videoGames) => l10n.progressPlayed,
      (ProgressStatus.finished, CategoryType.boardGames) => l10n.progressPlayedOnce,
      (ProgressStatus.finished, CategoryType.films) => l10n.progressWatched,
      (ProgressStatus.finished, CategoryType.music) => l10n.progressListened,
      (ProgressStatus.finished, CategoryType.lego) => l10n.progressBuilt,
      (ProgressStatus.finished, _) => l10n.progressFinished,
      (ProgressStatus.abandoned, _) => l10n.progressAbandoned,
    };

class ProgressSection extends StatefulWidget {
  const ProgressSection({required this.progress, required this.categoryType, required this.onChanged, super.key});

  final ItemProgress? progress;
  final CategoryType? categoryType;
  final ValueChanged<ItemProgress?> onChanged;

  @override
  State<ProgressSection> createState() => _ProgressSectionState();
}

class _ProgressSectionState extends State<ProgressSection> {
  late final TextEditingController _chapterController = TextEditingController(text: widget.progress?.chapter ?? '');
  late final TextEditingController _pageController = TextEditingController(text: widget.progress?.page?.toString() ?? '');

  @override
  void didUpdateWidget(covariant ProgressSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress?.chapter != widget.progress?.chapter && _chapterController.text != (widget.progress?.chapter ?? '')) {
      _chapterController.text = widget.progress?.chapter ?? '';
    }
    final page = widget.progress?.page?.toString() ?? '';
    if (oldWidget.progress?.page != widget.progress?.page && _pageController.text != page) {
      _pageController.text = page;
    }
  }

  @override
  void dispose() {
    _chapterController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _select(ProgressStatus status) {
    final current = widget.progress;
    if (current?.status == status) {
      widget.onChanged(null);
      return;
    }
    widget.onChanged(ItemProgress(status: status, chapter: current?.chapter, page: current?.page));
  }

  void _saveBookmark() {
    final current = widget.progress;
    if (current == null) {
      return;
    }
    final chapter = _chapterController.text.trim();
    final page = int.tryParse(_pageController.text.trim());
    if (chapter == (current.chapter ?? '') && page == current.page) {
      return;
    }
    widget.onChanged(ItemProgress(status: current.status, chapter: chapter.isEmpty ? null : chapter, page: page));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = widget.progress;
    final showsBookmark = (progress?.hasBookmark ?? false) && tracksReadingPlace(widget.categoryType);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.progressTitle, style: AkashicTypography.body(size: 14, weight: FontWeight.w800)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final status in progressStatusesFor(widget.categoryType))
              ChoiceChip(
                label: Text(progressStatusLabel(status, widget.categoryType, l10n)),
                selected: progress?.status == status,
                selectedColor: AkashicColors.lavender,
                showCheckmark: false,
                labelStyle: AkashicTypography.body(size: 13, weight: FontWeight.w600).copyWith(color: progress?.status == status ? AkashicColors.night : AkashicColors.text),
                onSelected: (_) => _select(status),
              ),
          ],
        ),
        if (showsBookmark) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Focus(
                  onFocusChange: (hasFocus) => hasFocus ? null : _saveBookmark(),
                  child: TextField(
                    controller: _chapterController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _saveBookmark(),
                    decoration: InputDecoration(labelText: l10n.progressChapter),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Focus(
                  onFocusChange: (hasFocus) => hasFocus ? null : _saveBookmark(),
                  child: TextField(
                    controller: _pageController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _saveBookmark(),
                    decoration: InputDecoration(labelText: l10n.progressPage),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
