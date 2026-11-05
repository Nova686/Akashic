import 'package:akashic/layers/technical/Theme/akashic_animation.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPanel extends StatelessWidget {
  const BarcodeScannerPanel({required this.onBarcode, super.key});

  final ValueChanged<String> onBarcode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          onDetect: (capture) {
            final value = capture.barcodes.map((barcode) => barcode.rawValue).nonNulls.firstOrNull;
            if (value != null) {
              onBarcode(value);
            }
          },
        ),
        Center(
          child: Container(
            width: 240,
            height: 120,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(border: Border.all(color: AkashicColors.lavender, width: 3), borderRadius: BorderRadius.circular(18)),
            child: const AkashicLottie(AkashicAnimation.scanSweep, size: 120, width: 240, fit: BoxFit.fill),
          ),
        ),
      ],
    );
  }
}
