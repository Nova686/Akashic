import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_type_labels.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:intl/intl.dart';

String apiDisplayName(String apiFamily) => sourceDisplayNames[apiFamily] ?? apiFamily;

String formatRemaining(Duration remaining) {
  final totalSeconds = remaining.inSeconds < 0 ? 0 : remaining.inSeconds;
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  return hours > 0 ? '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}' : '${twoDigits(minutes)}:${twoDigits(seconds)}';
}

String formatClock(AppLocalizations l10n, DateTime moment, DateTime now) {
  final sameDay = moment.year == now.year && moment.month == now.month && moment.day == now.day;
  return sameDay ? DateFormat.Hm(l10n.localeName).format(moment) : DateFormat.MMMd(l10n.localeName).add_Hm().format(moment);
}
