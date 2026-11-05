import 'package:akashic/layers/technical/AppShell/tour_targets.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Tour/guided_tour.dart';

List<TourStep> akashicTourSteps(AppLocalizations l10n) => [
      TourStep(title: l10n.tourWelcomeTitle, text: l10n.tourWelcomeText),
      TourStep(title: l10n.tourNewCategoryTitle, text: l10n.tourNewCategoryText, target: TourTargets.newCategory),
      TourStep(title: l10n.tourSearchTitle, text: l10n.tourSearchText, target: TourTargets.search),
      TourStep(title: l10n.tourScanTitle, text: l10n.tourScanText, target: TourTargets.scanButton),
      TourStep(title: l10n.tourMenuTitle, text: l10n.tourMenuText, target: TourTargets.menu),
      TourStep(title: l10n.tourWishesTitle, text: l10n.tourWishesText, target: TourTargets.wishesTab),
      TourStep(title: l10n.tourDiscoveriesTitle, text: l10n.tourDiscoveriesText, target: TourTargets.discoveriesTab),
      TourStep(title: l10n.tourReleasesTitle, text: l10n.tourReleasesText, target: TourTargets.releasesTab),
    ];

TourLabels akashicTourLabels(AppLocalizations l10n) =>
    TourLabels(previous: l10n.tourPrevious, next: l10n.tutorialNext, done: l10n.tourDone, close: l10n.close, progress: l10n.tourProgress);
