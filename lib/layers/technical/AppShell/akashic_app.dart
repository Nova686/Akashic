import 'dart:async';

import 'package:akashic/layers/technical/Tour/guided_tour.dart';
import 'package:akashic/layers/technical/AppShell/akashic_tour.dart';
import 'package:akashic/layers/technical/AppShell/akashic_router.dart';
import 'package:akashic/layers/technical/AppShell/dependency_scope.dart';
import 'package:akashic/layers/technical/AppShell/keyboard_focus.dart';
import 'package:akashic/layers/technical/Feedback/error_toast_host.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_theme.dart';
import 'package:akashic/layers/technical/Theme/system_navigation_band.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AkashicApp extends StatefulWidget {
  const AkashicApp({required this.dependencies, super.key});

  final AkashicDependencies dependencies;

  @override
  State<AkashicApp> createState() => _AkashicAppState();
}

class _AkashicAppState extends State<AkashicApp> with WidgetsBindingObserver {
  late final GoRouter _router = buildAkashicRouter(widget.dependencies);
  late final Stream<String?> _appLanguageCode = widget.dependencies.settingsGateway.watchAppLanguageCode();
  late final Stream<bool> _highContrast = widget.dependencies.settingsGateway.watchHighContrast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.dependencies.tourRequests.addListener(_startTour);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTourOnFirstLaunch());
  }

  OverlayEntry? _tour;

  Future<void> _showTourOnFirstLaunch() async {
    if (await widget.dependencies.manageTutorial.shouldShowOnFirstLaunch() && mounted) {
      _startTour();
    }
  }

  void _startTour() {
    if (_tour != null) {
      return;
    }
    _router.go('/');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = _router.routerDelegate.navigatorKey.currentState;
      final overlay = navigator?.overlay;
      if (!mounted || navigator == null || overlay == null || _tour != null) {
        return;
      }
      final l10n = AppLocalizations.of(navigator.context);
      late final OverlayEntry tour;
      tour = OverlayEntry(
        builder: (_) => GuidedTour(
          steps: akashicTourSteps(l10n),
          labels: akashicTourLabels(l10n),
          onFinished: () {
            tour.remove();
            _tour = null;
            unawaited(widget.dependencies.manageTutorial.markSeen());
          },
        ),
      );
      _tour = tour;
      overlay.insert(tour);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.paused) {
      widget.dependencies.homeScreenSummary.publish().then<void>((_) {}).catchError((Object _) {}, test: (error) => error is Exception);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.dependencies.tourRequests.removeListener(_startTour);
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _highContrast,
      builder: (context, contrast) => StreamBuilder<String?>(
      stream: _appLanguageCode,
      builder: (context, snapshot) {
        final languageCode = snapshot.data;
        final isHighContrast = (contrast.data ?? false) || (MediaQuery.maybeHighContrastOf(context) ?? false);
        AkashicColors.useHighContrast(isHighContrast);
        return MaterialApp.router(
          key: ValueKey(isHighContrast),
          title: 'Akashic',
          theme: buildAkashicTheme(),
          locale: languageCode == null ? null : Locale(languageCode),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
          builder: (context, child) => SystemNavigationBand(child: ErrorToastHost(child: TapOutsideClosesKeyboard(child: child ?? const SizedBox.shrink()))),
        );
      },
      ),
    );
  }
}
