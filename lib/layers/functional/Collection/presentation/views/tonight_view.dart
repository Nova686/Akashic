import 'dart:io';

import 'package:akashic/layers/functional/Collection/domain/use_cases/pick_tonight.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/tonight_cubit.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String tonightActivityLabel(TonightActivity activity, AppLocalizations l10n) => switch (activity) {
      TonightActivity.any => l10n.tonightAny,
      TonightActivity.read => l10n.tonightRead,
      TonightActivity.play => l10n.tonightPlay,
      TonightActivity.watch => l10n.tonightWatch,
      TonightActivity.listen => l10n.tonightListen,
    };

String tonightLengthLabel(TonightLength length, AppLocalizations l10n) => switch (length) {
      TonightLength.any => l10n.tonightAnyLength,
      TonightLength.short => l10n.tonightShort,
      TonightLength.medium => l10n.tonightMedium,
      TonightLength.long => l10n.tonightLong,
    };

class TonightView extends StatelessWidget {
  const TonightView({required this.onOpenItem, super.key});

  final ValueChanged<String> onOpenItem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<TonightCubit>();
    return BlocConsumer<TonightCubit, TonightState>(
      listenWhen: (previous, current) => current.startedTitle != null && previous.startedTitle != current.startedTitle,
      listener: (context, state) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.tonightStarted(state.startedTitle!)))),
      builder: (context, state) {
        final pick = state.pick;
        final title = pick == null ? '' : resolveDisplayTitle(pick.item.titles, PreferredLanguages.defaults) ?? l10n.untitled;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.tonightTitle, style: AkashicTypography.displayTitle(size: 26))),
          body: state.isLoading
              ? const AkashicLoader()
              : ListView(
                  padding: safeListPadding(context),
                  children: [
                    _ChipRow(children: [
                      for (final activity in TonightActivity.values)
                        ChoiceChip(label: Text(tonightActivityLabel(activity, l10n)), selected: state.activity == activity, onSelected: (_) => cubit.chooseActivity(activity)),
                    ]),
                    const SizedBox(height: 8),
                    _ChipRow(children: [
                      for (final length in TonightLength.values)
                        ChoiceChip(label: Text(tonightLengthLabel(length, l10n)), selected: state.length == length, onSelected: (_) => cubit.chooseLength(length)),
                    ]),
                    const SizedBox(height: 22),
                    if (pick == null)
                      Padding(padding: const EdgeInsets.only(top: 30), child: AkashicEmptyState(message: state.candidateCount == 0 ? l10n.tonightNothingWaiting : l10n.tonightNothingMatches))
                    else
                      Semantics(
                        liveRegion: true,
                        child: _TonightPick(pick: pick, title: title, onOpen: () => onOpenItem(pick.item.id)),
                      ),
                  ],
                ),
          bottomNavigationBar: pick == null
              ? null
              : SafeArea(
                  minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(child: OutlinedButton.icon(onPressed: cubit.drawAgain, icon: const Icon(Icons.casino_outlined), label: Text(l10n.tonightAnother))),
                      const SizedBox(width: 10),
                      Expanded(child: FilledButton.icon(onPressed: state.startedTitle == title ? null : () => cubit.start(title), icon: const Icon(Icons.play_arrow), label: Text(l10n.tonightStart))),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Wrap(spacing: 8, runSpacing: 8, children: children);
}

class _TonightPick extends StatelessWidget {
  const _TonightPick({required this.pick, required this.title, required this.onOpen});

  final TonightCandidate pick;
  final String title;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final item = pick.item;
    final imagePath = item.imagePath;
    final color = Color(item.spineColorValue ?? pick.category.colorValue);
    final waitingMonths = item.addedAt == null ? null : (DateTime.now().difference(item.addedAt!).inDays / 30).floor();
    return Column(
      children: [
        GestureDetector(
          onTap: onOpen,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 200,
              height: 280,
              child: imagePath == null
                  ? DecoratedBox(
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [color, AkashicColors.line], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                      child: Center(child: Text(title.characters.take(2).toString().toUpperCase(), style: AkashicTypography.displayTitle(size: 56))),
                    )
                  : Image.file(File(imagePath), fit: BoxFit.cover, cacheWidth: 600, errorBuilder: (context, error, stack) => ColoredBox(color: color)),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(title, textAlign: TextAlign.center, style: AkashicTypography.displayTitle(size: 26)),
        if (item.creator case final creator?) Text(creator, textAlign: TextAlign.center, style: AkashicTypography.body(size: 14).copyWith(color: AkashicColors.textSoft)),
        const SizedBox(height: 10),
        Text(
          [
            pick.category.name,
            if (pick.length case final length?) tonightLengthLabel(length, l10n),
            if (waitingMonths != null && waitingMonths >= 1) l10n.tonightWaitingSince(waitingMonths),
          ].join(' · '),
          textAlign: TextAlign.center,
          style: AkashicTypography.body(size: 13, weight: FontWeight.w700).copyWith(color: AkashicColors.teal),
        ),
      ],
    );
  }
}
