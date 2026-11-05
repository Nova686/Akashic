import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_type_labels.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';

String wishlistText(List<Wish> wishes, AppLocalizations l10n) {
  final byType = <CategoryType, List<Wish>>{};
  for (final wish in wishes) {
    byType.putIfAbsent(wish.categoryType, () => []).add(wish);
  }
  final types = byType.keys.toList()..sort((first, second) => first.index.compareTo(second.index));
  final lines = <String>[l10n.wishlistShareHeading, ''];
  for (final type in types) {
    lines.add(type.label(l10n));
    for (final wish in byType[type]!..sort((first, second) => first.title.toLowerCase().compareTo(second.title.toLowerCase()))) {
      final creator = wish.creator;
      lines.add(creator == null || creator.trim().isEmpty ? '• ${wish.title}' : '• ${wish.title} — $creator');
    }
    lines.add('');
  }
  return lines.join('\n').trimRight();
}
