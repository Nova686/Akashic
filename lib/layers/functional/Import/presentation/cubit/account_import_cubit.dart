import 'dart:async';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:akashic/layers/functional/Import/domain/entities/linked_account.dart';
import 'package:akashic/layers/functional/Import/domain/entities/linked_account_sync_progress.dart';
import 'package:akashic/layers/functional/Import/domain/gateways/linked_account_gateway.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/sync_linked_accounts.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/presentation/source_failure_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AccountImportStatus { choosing, importing, done, accountNotFound, unreadableFile, failed }

class AccountImportState extends Equatable {
  const AccountImportState({
    required this.service,
    this.readsFile = false,
    this.accountField = AccountField.accountName,
    this.accountName = '',
    this.password = '',
    this.exportFileName,
    this.keepSynced = true,
    this.linkedAccounts = const [],
    this.syncingService,
    this.notFoundProblem = LibraryProblem.unknownAccount,
    this.selectedCategoryId,
    this.status = AccountImportStatus.choosing,
    this.done = 0,
    this.total = 0,
    this.outcome,
  });

  final LibraryService service;
  final bool readsFile;
  final AccountField accountField;
  final String accountName;
  final String password;
  final String? exportFileName;
  final bool keepSynced;
  final List<LinkedAccount> linkedAccounts;
  final LibraryService? syncingService;
  final LibraryProblem notFoundProblem;
  final String? selectedCategoryId;
  final AccountImportStatus status;
  final int done;
  final int total;
  final LibraryImportOutcome? outcome;

  bool get hasCredentials => switch ((readsFile, accountField)) {
        (true, _) => exportFileName != null,
        (false, AccountField.accountAndPassword) => accountName.trim().isNotEmpty && password.isNotEmpty,
        (false, _) => accountName.trim().isNotEmpty,
      };

  bool get canStart => hasCredentials && selectedCategoryId != null && status != AccountImportStatus.importing;

  AccountImportState copyWith({
    LibraryService? service,
    bool? readsFile,
    AccountField? accountField,
    String? accountName,
    String? password,
    String? Function()? exportFileName,
    bool? keepSynced,
    List<LinkedAccount>? linkedAccounts,
    LibraryService? Function()? syncingService,
    LibraryProblem? notFoundProblem,
    String? Function()? selectedCategoryId,
    AccountImportStatus? status,
    int? done,
    int? total,
    LibraryImportOutcome? Function()? outcome,
  }) =>
      AccountImportState(
        service: service ?? this.service,
        readsFile: readsFile ?? this.readsFile,
        accountField: accountField ?? this.accountField,
        accountName: accountName ?? this.accountName,
        password: password ?? this.password,
        exportFileName: exportFileName == null ? this.exportFileName : exportFileName(),
        keepSynced: keepSynced ?? this.keepSynced,
        linkedAccounts: linkedAccounts ?? this.linkedAccounts,
        syncingService: syncingService == null ? this.syncingService : syncingService(),
        notFoundProblem: notFoundProblem ?? this.notFoundProblem,
        selectedCategoryId: selectedCategoryId == null ? this.selectedCategoryId : selectedCategoryId(),
        status: status ?? this.status,
        done: done ?? this.done,
        total: total ?? this.total,
        outcome: outcome == null ? this.outcome : outcome(),
      );

  @override
  List<Object?> get props => [service, readsFile, accountField, accountName, password, exportFileName, keepSynced, linkedAccounts, syncingService, notFoundProblem, selectedCategoryId, status, done, total, outcome];
}

class AccountImportCubit extends Cubit<AccountImportState> {
  AccountImportCubit(this._importAccountLibrary, {required List<LibrarySource> libraries, required this.categories, this._linkedAccounts, this._syncLinkedAccounts, DateTime Function()? now})
      : _libraries = {for (final library in libraries) library.service: library},
        _now = now ?? DateTime.now,
        super(AccountImportState(service: libraries.first.service)) {
    chooseService(libraries.first.service);
    _linkedSubscription = _linkedAccounts?.watchAll().listen((linked) {
      if (!isClosed) {
        emit(state.copyWith(linkedAccounts: linked));
      }
    });
    if (_syncLinkedAccounts?.currentProgress case final running?) {
      emit(state.copyWith(syncingService: () => running.service));
    }
    _progressSubscription = _syncLinkedAccounts?.progress.listen((progress) {
      if (!isClosed) {
        emit(state.copyWith(syncingService: () => progress?.service));
      }
    });
  }

  StreamSubscription<LinkedAccountSyncProgress?>? _progressSubscription;

  final LinkedAccountGateway? _linkedAccounts;
  final SyncLinkedAccounts? _syncLinkedAccounts;
  final DateTime Function() _now;
  StreamSubscription<List<LinkedAccount>>? _linkedSubscription;

  bool get canKeepCurrentSynced => _linkedAccounts != null && canKeepSynced(_library);

  String? categoryNameOf(String categoryId) => categories.where((category) => category.id == categoryId).firstOrNull?.name;

  void setKeepSynced(bool keepSynced) => emit(state.copyWith(keepSynced: keepSynced));

  Future<void> syncNow(LinkedAccount account) async {
    final sync = _syncLinkedAccounts;
    if (sync == null || state.syncingService != null) {
      return;
    }
    emit(state.copyWith(syncingService: () => account.service));
    try {
      await sync.syncOne(account);
    } finally {
      if (!isClosed) {
        emit(state.copyWith(syncingService: () => null));
      }
    }
  }

  Future<void> unlink(LibraryService service) async => _linkedAccounts?.remove(service);

  @override
  Future<void> close() async {
    await _progressSubscription?.cancel();
    await _linkedSubscription?.cancel();
    return super.close();
  }

  final ImportAccountLibrary _importAccountLibrary;
  final Map<LibraryService, LibrarySource> _libraries;
  Uint8List? _exportBytes;
  final List<Category> categories;

  List<LibraryService> get services => _libraries.keys.toList();

  LibrarySource get _library => _libraries[state.service]!;

  bool get isConfigured => _library.isConfigured;

  List<Category> get targetCategories => [for (final category in categories) if (category.type == _library.categoryType) category];

  void chooseService(LibraryService service) {
    if (state.status == AccountImportStatus.importing) {
      return;
    }
    final targets = [for (final category in categories) if (category.type == _libraries[service]!.categoryType) category];
    _exportBytes = null;
    emit(state.copyWith(
      service: service,
      readsFile: _libraries[service] is ExportFileLibrary,
      accountField: switch (_libraries[service]) {
        final AccountLibrary library => library.accountField,
        _ => AccountField.accountName,
      },
      accountName: '',
      password: '',
      exportFileName: () => null,
      selectedCategoryId: () => targets.firstOrNull?.id,
      status: AccountImportStatus.choosing,
      outcome: () => null,
    ));
  }

  void chooseExportFile(String fileName, Uint8List bytes) {
    _exportBytes = bytes;
    emit(state.copyWith(exportFileName: () => fileName, status: AccountImportStatus.choosing, outcome: () => null));
  }

  void setAccountName(String accountName) => emit(state.copyWith(accountName: accountName));

  void setPassword(String password) => emit(state.copyWith(password: password));

  void chooseCategory(String categoryId) => emit(state.copyWith(selectedCategoryId: () => categoryId));

  Future<void> start() async {
    final categoryId = state.selectedCategoryId;
    if (!state.canStart || categoryId == null || !isConfigured) {
      return;
    }
    emit(state.copyWith(status: AccountImportStatus.importing, done: 0, total: 0, outcome: () => null));
    try {
      void onProgress(int done, int total) {
        if (!isClosed) {
          emit(state.copyWith(done: done, total: total));
        }
      }

      final outcome = switch ((_library, state.exportFileName, _exportBytes)) {
        (final ExportFileLibrary library, final fileName?, final bytes?) => await _importAccountLibrary.fromFile(library, fileName, bytes, categoryId: categoryId, onProgress: onProgress),
        (final AccountLibrary library, _, _) => await _importAccountLibrary(library, state.accountName, password: state.password, categoryId: categoryId, onProgress: onProgress),
        _ => null,
      };
      if (outcome == null) {
        return;
      }
      final library = _library;
      if (state.keepSynced && canKeepCurrentSynced && library is AccountLibrary) {
        final linked = LinkedAccount(
          service: library.service,
          accountName: state.accountName.trim(),
          categoryId: categoryId,
          seenKeys: outcome.seenKeys,
          lastSyncedAt: _now(),
          lastAdded: outcome.added,
        );
        await _linkedAccounts?.save(linked);
        unawaited(_syncLinkedAccounts?.followUp(linked));
      }
      if (!isClosed) {
        emit(state.copyWith(status: AccountImportStatus.done, outcome: () => outcome));
      }
    } on UnreadableSpreadsheet {
      if (!isClosed) {
        emit(state.copyWith(status: AccountImportStatus.unreadableFile));
      }
    } on LibraryNotFound catch (notFound) {
      if (!isClosed) {
        emit(state.copyWith(status: AccountImportStatus.accountNotFound, notFoundProblem: notFound.problem));
      }
    } on SourceUnavailable catch (failure) {
      showSourceFailure(failure);
      if (!isClosed) {
        emit(state.copyWith(status: AccountImportStatus.failed));
      }
    }
  }
}
