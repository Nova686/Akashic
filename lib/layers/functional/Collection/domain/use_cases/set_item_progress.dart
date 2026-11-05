import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';
import 'package:akashic/layers/functional/Activity/domain/gateways/activity_log.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';

class SetItemProgress {
  const SetItemProgress(this._collection, {this._activityLog, this._now});

  final CollectionGateway _collection;
  final ActivityLog? _activityLog;
  final DateTime Function()? _now;

  Future<void> call(String itemId, ItemProgress? progress) async {
    final chapter = progress?.chapter?.trim();
    final log = _activityLog;
    final before = log == null ? null : await _collection.watchItem(itemId).first;
    await _collection.saveProgress(
      itemId,
      progress == null ? null : ItemProgress(status: progress.status, chapter: chapter == null || chapter.isEmpty ? null : chapter, page: progress.page),
    );
    final kind = switch (progress?.status) {
      ProgressStatus.inProgress => ActivityKind.started,
      ProgressStatus.finished => ActivityKind.finished,
      _ => null,
    };
    if (log == null || before == null || kind == null || before.progress?.status == progress?.status) {
      return;
    }
    await log.record(ActivityEvent(
      kind: kind,
      title: resolveDisplayTitle(before.titles, PreferredLanguages.defaults) ?? '',
      at: (_now ?? DateTime.now)(),
      itemId: itemId,
      categoryId: before.categoryId,
    ));
  }
}
