import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:equatable/equatable.dart';

sealed class CheckVerdict extends Equatable {
  const CheckVerdict();
}

class Owned extends CheckVerdict {
  const Owned(this.item, this.copies);

  final CollectionItem item;
  final List<ItemCopy> copies;

  @override
  List<Object?> get props => [item, copies];
}

class OwnedOtherEdition extends CheckVerdict {
  const OwnedOtherEdition(this.item, this.copies, this.match);

  final CollectionItem item;
  final List<ItemCopy> copies;
  final SourceMatch match;

  @override
  List<Object?> get props => [item, copies, match];
}

class NotOwned extends CheckVerdict {
  const NotOwned(this.match, this.query);

  final SourceMatch? match;
  final String query;

  @override
  List<Object?> get props => [match, query];
}

class CatalogsUnavailable extends CheckVerdict {
  const CatalogsUnavailable(this.query, {this.rateLimitedSources = const []});

  final String query;
  final List<String> rateLimitedSources;

  bool get isRateLimited => rateLimitedSources.isNotEmpty;

  @override
  List<Object?> get props => [query, rateLimitedSources];
}
