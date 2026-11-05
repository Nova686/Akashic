import 'package:akashic/layers/functional/Check/domain/entities/scan_session.dart';

abstract interface class ScanHistoryGateway {
  Future<void> save(ScanSession session);
  Stream<List<ScanSession>> watchAll();
}
