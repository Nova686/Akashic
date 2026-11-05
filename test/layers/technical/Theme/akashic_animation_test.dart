import 'dart:io';

import 'package:akashic/layers/technical/Theme/akashic_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

void main() {
  for (final animation in AkashicAnimation.values) {
    test('${animation.name} is a valid composition', () async {
      final bytes = await File(animation.assetPath).readAsBytes();
      final composition = await LottieComposition.fromBytes(bytes);
      expect(composition.duration, greaterThan(Duration.zero));
      expect(composition.layers, isNotEmpty);
    });
  }

  testWidgets('reduced motion keeps the animation still', (tester) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: Directionality(textDirection: TextDirection.ltr, child: AkashicLottie(AkashicAnimation.orbitLoader)),
      ),
    );
    final lottie = tester.widget<LottieBuilder>(find.byType(LottieBuilder));
    expect((lottie as dynamic).animate, isFalse);
  });
}
