import 'package:akashic/layers/functional/Lookup/domain/entities/precon_deck.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';

String preconGroupLabel(PreconDeck deck, AppLocalizations l10n) => deck.isCommander ? l10n.commanderDeckGroup : l10n.preconDeckGroup;
