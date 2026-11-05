import 'package:akashic/layers/functional/Collection/domain/entities/trade_channel.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';

String tradeChannelLabel(TradeChannel channel, AppLocalizations l10n) => switch (channel) {
      TradeChannel.store => l10n.channelStore,
      TradeChannel.online => l10n.channelOnline,
    };
