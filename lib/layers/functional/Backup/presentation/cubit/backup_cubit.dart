import 'dart:async';

import 'package:akashic/layers/functional/Backup/domain/entities/backup.dart';
import 'package:akashic/layers/functional/Backup/domain/gateways/backup_ports.dart';
import 'package:akashic/layers/functional/Backup/domain/use_cases/backup_use_cases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum BackupNotice { none, backedUp, exported, unavailable, authorizationRefused, corrupt, noRemoteBackup, restoreStaged, restoreFailed }

class BackupState extends Equatable {
  const BackupState({this.lastBackupAt, this.needsReconnect = false, this.isWorking = false, this.remoteBackups = const [], this.notice = BackupNotice.none});

  final DateTime? lastBackupAt;
  final bool needsReconnect;
  final bool isWorking;
  final List<RemoteBackup> remoteBackups;
  final BackupNotice notice;

  BackupState copyWith({DateTime? Function()? lastBackupAt, bool? needsReconnect, bool? isWorking, List<RemoteBackup>? remoteBackups, BackupNotice? notice}) {
    return BackupState(
      lastBackupAt: lastBackupAt == null ? this.lastBackupAt : lastBackupAt(),
      needsReconnect: needsReconnect ?? this.needsReconnect,
      isWorking: isWorking ?? this.isWorking,
      remoteBackups: remoteBackups ?? this.remoteBackups,
      notice: notice ?? BackupNotice.none,
    );
  }

  @override
  List<Object?> get props => [lastBackupAt, needsReconnect, isWorking, remoteBackups, notice];
}

class BackupCubit extends Cubit<BackupState> {
  BackupCubit({
    required this._backUp,
    required this._listBackups,
    required this._restore,
    required this._storage,
    required this._status,
    required this._archiver,
    this._exportCollection,
    this._restoreFromFile,
  }) : super(const BackupState());

  final BackUpCollection _backUp;
  final ListRemoteBackups _listBackups;
  final RestoreCollection _restore;
  final BackupStorage _storage;
  final BackupStatusGateway _status;
  final CollectionArchiver _archiver;
  final ExportCollection? _exportCollection;
  final RestoreCollectionFromFile? _restoreFromFile;

  bool get canUseFiles => _exportCollection != null && _restoreFromFile != null;
  StreamSubscription<DateTime?>? _subscription;

  Future<void> start() async {
    _subscription = _status.watchLastBackupAt().listen((lastBackupAt) {
      if (!isClosed) {
        emit(state.copyWith(lastBackupAt: () => lastBackupAt));
      }
    });
    final lastBackupAt = await _status.watchLastBackupAt().first;
    final restoreFailed = await _archiver.takeFailedRestore();
    final isAuthorized = await _storage.hasAuthorization();
    if (!isClosed) {
      emit(state.copyWith(
        lastBackupAt: () => lastBackupAt,
        needsReconnect: !isAuthorized && lastBackupAt != null,
        notice: restoreFailed ? BackupNotice.restoreFailed : null,
      ));
    }
  }

  Future<void> _work(Future<BackupNotice> Function() task) async {
    if (state.isWorking) {
      return;
    }
    emit(state.copyWith(isWorking: true));
    var notice = BackupNotice.unavailable;
    try {
      notice = await task();
    } on BackupAuthorizationRequired {
      notice = BackupNotice.authorizationRefused;
    } on BackupStorageUnavailable {
      notice = BackupNotice.unavailable;
    } on CorruptBackup {
      notice = BackupNotice.corrupt;
    } on Exception {
      notice = BackupNotice.unavailable;
    } finally {
      if (!isClosed) {
        emit(state.copyWith(isWorking: false, notice: notice, needsReconnect: notice == BackupNotice.authorizationRefused ? null : false));
      }
    }
  }

  Future<void> backUpNow() => _work(() async {
        await _backUp(canAskToSignIn: true);
        return BackupNotice.backedUp;
      });

  Future<void> loadRemoteBackups() => _work(() async {
        final backups = await _listBackups();
        if (!isClosed) {
          emit(state.copyWith(remoteBackups: backups, isWorking: true));
        }
        return backups.isEmpty ? BackupNotice.noRemoteBackup : BackupNotice.none;
      });

  Future<void> restore(RemoteBackup backup) => _work(() async {
        await _restore(backup);
        return BackupNotice.restoreStaged;
      });

  Future<void> exportToFile() => _work(() async {
        final exportCollection = _exportCollection;
        if (exportCollection == null) {
          return BackupNotice.none;
        }
        return await exportCollection() ? BackupNotice.exported : BackupNotice.none;
      });

  Future<void> restoreFromFile() => _work(() async {
        final restoreFromFile = _restoreFromFile;
        if (restoreFromFile == null) {
          return BackupNotice.none;
        }
        return await restoreFromFile() == null ? BackupNotice.none : BackupNotice.restoreStaged;
      });

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
