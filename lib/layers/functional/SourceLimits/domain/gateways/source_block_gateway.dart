import 'package:akashic/layers/functional/SourceLimits/domain/entities/source_block.dart';

abstract interface class SourceBlockGateway {
  Stream<List<SourceBlock>> watchBlocks();
}
