import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum AkashicAnimation {
  twinklingStars('twinkling_stars', loops: true),
  ownedBurst('owned_burst', loops: false),
  scanSweep('scan_sweep', loops: true),
  orbitLoader('orbit_loader', loops: true),
  addedCheck('added_check', loops: false);

  const AkashicAnimation(this.fileName, {required this.loops});

  final String fileName;
  final bool loops;

  String get assetPath => 'assets/animations/$fileName.json';
}

class AkashicLottie extends StatelessWidget {
  const AkashicLottie(this.animation, {super.key, this.size = 120, this.width, this.fit = BoxFit.contain});

  final AkashicAnimation animation;
  final double size;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final isMotionReduced = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return ExcludeSemantics(
      child: SizedBox(
        width: width ?? size,
        height: size,
        child: Lottie.asset(
          animation.assetPath,
          fit: fit,
          repeat: animation.loops,
          animate: !isMotionReduced,
          frameRate: FrameRate.composition,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
