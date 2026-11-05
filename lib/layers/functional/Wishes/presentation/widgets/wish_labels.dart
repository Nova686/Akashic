import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';

extension WishOriginLabel on WishOrigin {
  String label(AppLocalizations l10n) => switch (this) {
        WishOrigin.discovery => l10n.wishOriginDiscovery,
        WishOrigin.search => l10n.wishOriginSearch,
        WishOrigin.missingVolume => l10n.wishOriginMissingVolume,
        WishOrigin.manual => l10n.wishOriginManual,
        WishOrigin.steamWishlist => l10n.wishOriginSteamWishlist,
      };
}

extension WishDisplayTitle on Wish {
  String displayTitle(AppLocalizations l10n) => switch (key.volumeNumber) {
        final number? when key.seriesId != null => l10n.wishVolumeTitle(title, number),
        _ => title,
      };
}
