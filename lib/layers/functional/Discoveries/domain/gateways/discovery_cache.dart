import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';

abstract interface class DiscoveryCacheGateway {
  Future<Discoveries?> read();
  Future<void> write(Discoveries discoveries);
}
