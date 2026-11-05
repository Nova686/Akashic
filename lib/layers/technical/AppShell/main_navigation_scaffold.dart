import 'package:akashic/layers/technical/AppShell/tour_targets.dart';
import 'package:akashic/layers/technical/AppShell/keyboard_focus.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationScaffold extends StatelessWidget {
  const MainNavigationScaffold({required this.navigationShell, this.statusBanner, super.key});

  final StatefulNavigationShell navigationShell;
  final Widget? statusBanner;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ?statusBanner,
          NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              dropKeyboardFocus();
              navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
            },
            destinations: [
              NavigationDestination(icon: const Icon(Icons.shelves), label: l10n.navCollection),
              NavigationDestination(key: TourTargets.wishesTab, icon: const Icon(Icons.favorite_border), label: l10n.navWishes),
              NavigationDestination(key: TourTargets.discoveriesTab, icon: const Icon(Icons.auto_awesome_outlined), label: l10n.navDiscoveries),
              NavigationDestination(key: TourTargets.releasesTab, icon: const Icon(Icons.event_outlined), label: l10n.navReleases),
            ],
          ),
        ],
      ),
    );
  }
}
