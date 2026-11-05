import 'dart:convert';

import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/arrange_shelf.dart';

String encodeShelfFilter(ShelfFilter filter) => jsonEncode({
      'progressStatus': ?filter.progressStatus?.name,
      'minimumRating': ?filter.minimumRating,
      'sealing': ?filter.sealing?.name,
      if (filter.onlyLent) 'onlyLent': true,
      'location': ?filter.location,
      'tag': ?filter.tag,
    });

ShelfFilter decodeShelfFilter(String encoded) {
  final values = jsonDecode(encoded) as Map<String, Object?>;
  return ShelfFilter(
    progressStatus: ProgressStatus.values.asNameMap()[values['progressStatus']],
    minimumRating: values['minimumRating'] as int?,
    sealing: SealingFilter.values.asNameMap()[values['sealing']],
    onlyLent: values['onlyLent'] == true,
    location: values['location'] as String?,
    tag: values['tag'] as String?,
  );
}
