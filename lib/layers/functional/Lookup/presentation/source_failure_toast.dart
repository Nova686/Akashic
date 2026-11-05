import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_type_labels.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/technical/Feedback/error_toasts.dart';

void showSourceFailure(SourceUnavailable failure, {ErrorToasts? errorToasts}) {
  final sourceName = sourceDisplayNames[failure.sourceKey.split('-').first] ?? failure.sourceKey;
  (errorToasts ?? ErrorToasts.instance).show(
    (l10n) => failure.isRateLimited ? l10n.sourceRateLimitedToast(sourceName) : l10n.sourceUnreachableToast(sourceName),
  );
}
