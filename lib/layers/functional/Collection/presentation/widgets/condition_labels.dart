import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';

extension ItemConditionLabel on ItemCondition {
  String label(AppLocalizations l10n) => switch (this) {
        ItemCondition.mint => l10n.conditionMint,
        ItemCondition.veryGood => l10n.conditionVeryGood,
        ItemCondition.good => l10n.conditionGood,
        ItemCondition.fair => l10n.conditionFair,
        ItemCondition.damaged => l10n.conditionDamaged,
        ItemCondition.missing => l10n.conditionMissing,
      };
}
