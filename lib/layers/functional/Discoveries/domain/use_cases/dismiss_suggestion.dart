import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/discovery_cache.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/dismissed_suggestion_gateway.dart';

class DismissSuggestion {
  DismissSuggestion(this._dismissed, this._cache);

  final DismissedSuggestionGateway _dismissed;
  final DiscoveryCacheGateway _cache;

  Future<void> call(Suggestion suggestion) async {
    await _dismissed.dismiss(suggestion.dismissalIdentities);
    final cached = await _cache.read();
    if (cached != null) {
      await _cache.write(cached.withoutSuggestion(suggestion));
    }
  }
}
