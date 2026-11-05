import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

Stream<bool> watchOffline({Connectivity? connectivity}) async* {
  final source = connectivity ?? Connectivity();
  bool isOff(List<ConnectivityResult> results) => results.isEmpty || results.every((result) => result == ConnectivityResult.none);
  yield isOff(await source.checkConnectivity());
  yield* source.onConnectivityChanged.map(isOff);
}

class OfflinePill extends StatelessWidget {
  const OfflinePill({required this.isOffline, super.key});

  final Stream<bool> isOffline;

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        stream: isOffline,
        builder: (context, snapshot) {
          if (snapshot.data != true) {
            return const SizedBox.shrink();
          }
          final l10n = AppLocalizations.of(context);
          return Semantics(
            liveRegion: true,
            label: l10n.offlineExplained,
            excludeSemantics: true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AkashicColors.gold.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(999), border: Border.all(color: AkashicColors.gold)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 13, color: AkashicColors.gold),
                  const SizedBox(width: 4),
                  Text(l10n.offline, style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.gold)),
                ],
              ),
            ),
          );
        },
      );
}
