import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_animation.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class AkashicEmptyState extends StatelessWidget {
  const AkashicEmptyState({super.key, required this.message, this.animation = AkashicAnimation.twinklingStars, this.animationSize = 120, this.action});

  final String message;
  final AkashicAnimation animation;
  final double animationSize;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AkashicLottie(animation, size: animationSize),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: AkashicTypography.body().copyWith(color: AkashicColors.textSoft)),
          if (action case final action?) ...[const SizedBox(height: 12), action],
        ],
      ),
    );
  }
}

class AkashicLoader extends StatelessWidget {
  const AkashicLoader({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) => Center(
        child: Semantics(
          label: AppLocalizations.of(context).loadingInProgress,
          liveRegion: true,
          child: AkashicLottie(AkashicAnimation.orbitLoader, size: size),
        ),
      );
}

class LabelledSpinner extends StatelessWidget {
  const LabelledSpinner({super.key});

  @override
  Widget build(BuildContext context) => CircularProgressIndicator(semanticsLabel: AppLocalizations.of(context).loadingInProgress);
}
