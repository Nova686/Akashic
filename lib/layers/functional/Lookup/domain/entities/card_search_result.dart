import 'package:equatable/equatable.dart';

class CardSearchResult extends Equatable {
  const CardSearchResult({required this.name, this.externalCardId, this.setName, this.imageUrl, this.sourceKey});

  final String name;
  final String? externalCardId;
  final String? setName;
  final String? imageUrl;
  final String? sourceKey;

  @override
  List<Object?> get props => [name, externalCardId, setName, imageUrl, sourceKey];
}
