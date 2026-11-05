import 'dart:io';

import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

Color scanStatusColor(ChainEntry entry) => switch (entry.status) {
      ChainEntryStatus.found => AkashicColors.teal,
      ChainEntryStatus.alreadyOwned => AkashicColors.lavender,
      ChainEntryStatus.resolving => AkashicColors.textFaint,
      _ => AkashicColors.gold,
    };

String initialsOf(String title) {
  final words = title.split(RegExp(r'[^\p{L}\p{N}]+', unicode: true)).where((word) => word.isNotEmpty).toList();
  return switch (words) {
    [] => '?',
    [final single] => single.substring(0, single.length < 2 ? single.length : 2),
    [final first, final second, ...] => '${first[0].toUpperCase()}${second[0]}',
  };
}

class ScanEntryCover extends StatelessWidget {
  const ScanEntryCover({required this.entry, required this.title, this.width = 40, super.key});

  final ChainEntry entry;
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    final height = width * 1.4;
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scanStatusColor(entry).withValues(alpha: 0.55), AkashicColors.line],
        ),
      ),
      child: Center(
        child: entry.status == ChainEntryStatus.resolving
            ? SizedBox.square(dimension: width * 0.4, child: CircularProgressIndicator(strokeWidth: 2, color: AkashicColors.textSoft))
            : Text(entry.hasFailed ? '?' : initialsOf(title), style: AkashicTypography.numeral(size: width * 0.34).copyWith(color: AkashicColors.text)),
      ),
    );
    final image = switch ((entry.ownedImagePath, entry.match?.imageUrl)) {
      (final path?, _) => Image.file(File(path), fit: BoxFit.cover, cacheWidth: (width * 3).round(), errorBuilder: (context, error, stack) => placeholder),
      (null, final url?) => Image.network(url, fit: BoxFit.cover, cacheWidth: (width * 3).round(), errorBuilder: (context, error, stack) => placeholder),
      _ => placeholder,
    };
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(width: width, height: height, child: image),
    );
  }
}
