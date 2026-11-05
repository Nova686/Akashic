import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:equatable/equatable.dart';

class LinkedAccount extends Equatable {
  const LinkedAccount({required this.service, required this.accountName, required this.categoryId, this.seenKeys = const {}, this.lastSyncedAt, this.lastAdded = 0});

  final LibraryService service;
  final String accountName;
  final String categoryId;
  final Set<String> seenKeys;
  final DateTime? lastSyncedAt;
  final int lastAdded;

  LinkedAccount synced({required Set<String> seenKeys, required DateTime at, required int added}) =>
      LinkedAccount(service: service, accountName: accountName, categoryId: categoryId, seenKeys: {...this.seenKeys, ...seenKeys}, lastSyncedAt: at, lastAdded: added);

  @override
  List<Object?> get props => [service, accountName, categoryId, seenKeys, lastSyncedAt, lastAdded];
}
