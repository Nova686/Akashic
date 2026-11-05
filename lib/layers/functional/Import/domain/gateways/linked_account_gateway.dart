import 'package:akashic/layers/functional/Import/domain/entities/linked_account.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';

abstract interface class LinkedAccountGateway {
  Stream<List<LinkedAccount>> watchAll();
  Future<void> save(LinkedAccount account);
  Future<void> remove(LibraryService service);
}
