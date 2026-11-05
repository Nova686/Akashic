import 'dart:async';

import 'package:akashic/layers/functional/Import/domain/entities/linked_account.dart';
import 'package:akashic/layers/functional/Import/domain/entities/linked_account_sync_progress.dart';
import 'package:akashic/layers/functional/Import/domain/gateways/linked_account_gateway.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';

const Set<AccountField> syncableAccountFields = {AccountField.accountName};

bool canKeepSynced(LibrarySource library) => library is AccountLibrary && syncableAccountFields.contains(library.accountField);

class SyncLinkedAccounts {
  SyncLinkedAccounts(this._accounts, List<LibrarySource> libraries, this._importAccountLibrary, {this._followUps = const {}, DateTime Function()? now})
      : _libraries = {for (final library in libraries) library.service: library},
        _now = now ?? DateTime.now;

  static const Duration syncEvery = Duration(hours: 6);

  final LinkedAccountGateway _accounts;
  final Map<LibraryService, LibrarySource> _libraries;
  final ImportAccountLibrary _importAccountLibrary;
  final Map<LibraryService, Future<void> Function(LinkedAccount account)> _followUps;
  final DateTime Function() _now;
  final StreamController<LinkedAccountSyncProgress?> _progress = StreamController<LinkedAccountSyncProgress?>.broadcast();
  LinkedAccountSyncProgress? _current;

  LinkedAccountSyncProgress? get currentProgress => _current;

  Stream<LinkedAccountSyncProgress?> get progress => _progress.stream;

  void _report(LinkedAccountSyncProgress? progress) {
    _current = progress;
    _progress.add(progress);
  }

  Future<int> call({bool force = false}) async {
    var added = 0;
    for (final account in await _accounts.watchAll().first) {
      final lastSyncedAt = account.lastSyncedAt;
      if (!force && lastSyncedAt != null && _now().difference(lastSyncedAt) < syncEvery) {
        continue;
      }
      added += await syncOne(account) ?? 0;
    }
    return added;
  }

  Future<void> followUp(LinkedAccount account) async {
    final followUp = _followUps[account.service];
    if (followUp == null) {
      return;
    }
    final previous = _current;
    _report(LinkedAccountSyncProgress(service: account.service, isRefreshingDetails: true));
    try {
      await followUp(account);
    } on Exception {
      return;
    } finally {
      _report(previous);
    }
  }

  final Map<LibraryService, Future<int?>> _running = {};

  Future<int?> syncOne(LinkedAccount account) => _running[account.service] ??= _syncOne(account).whenComplete(() {
        _running.remove(account.service);
      });

  Future<int?> _syncOne(LinkedAccount account) async {
    final library = _libraries[account.service];
    if (library is! AccountLibrary || !library.isConfigured) {
      return null;
    }
    _report(LinkedAccountSyncProgress(service: account.service));
    try {
      final outcome = await _importAccountLibrary(
        library,
        account.accountName,
        categoryId: account.categoryId,
        skippedKeys: account.seenKeys,
        onProgress: (done, total) => _report(LinkedAccountSyncProgress(service: account.service, done: done, total: total)),
      );
      final current = (await _accounts.watchAll().first).where((linked) => linked.service == account.service).firstOrNull;
      if (current == null || current.accountName != account.accountName) {
        return outcome.added;
      }
      await _accounts.save(current.synced(seenKeys: outcome.seenKeys, at: _now(), added: outcome.added));
      await followUp(current);
      return outcome.added;
    } on LibraryNotFound {
      return null;
    } on SourceUnavailable {
      return null;
    } finally {
      _report(null);
    }
  }
}
