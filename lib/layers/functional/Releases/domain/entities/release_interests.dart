import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:equatable/equatable.dart';

class FollowedSeries extends Equatable {
  const FollowedSeries({required this.seriesId, required this.title, required this.nextVolume, this.isWished = false});

  final String seriesId;
  final String title;
  final int nextVolume;
  final bool isWished;

  @override
  List<Object?> get props => [seriesId, title, nextVolume, isWished];
}

class ReleaseInterests extends Equatable {
  const ReleaseInterests({this.cardGames = const {}, this.series = const [], this.artists = const [], this.ownedTitles = const {}});

  final Set<CardGame> cardGames;
  final List<FollowedSeries> series;
  final List<String> artists;
  final Set<String> ownedTitles;

  int get followedSubjects => cardGames.length + series.length + artists.length;

  @override
  List<Object?> get props => [cardGames, series, artists, ownedTitles];
}
