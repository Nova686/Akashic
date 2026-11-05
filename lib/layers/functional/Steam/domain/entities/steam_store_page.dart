import 'package:equatable/equatable.dart';

class SteamPrice extends Equatable {
  const SteamPrice({required this.initialCents, required this.finalCents, required this.discountPercent, required this.currency});

  final int initialCents;
  final int finalCents;
  final int discountPercent;
  final String currency;

  bool get isDiscounted => discountPercent > 0 && finalCents < initialCents;

  @override
  List<Object?> get props => [initialCents, finalCents, discountPercent, currency];
}

class SteamScreenshot extends Equatable {
  const SteamScreenshot({required this.thumbnailUrl, required this.fullUrl});

  final String thumbnailUrl;
  final String fullUrl;

  @override
  List<Object?> get props => [thumbnailUrl, fullUrl];
}

class SteamStorePage extends Equatable {
  const SteamStorePage({
    required this.appId,
    required this.name,
    this.shortDescription,
    this.genres = const [],
    this.features = const [],
    this.developers = const [],
    this.publishers = const [],
    this.releaseDate,
    this.isComingSoon = false,
    this.screenshots = const [],
    this.trailerThumbnailUrl,
    this.trailerName,
    this.price,
    this.isFree = false,
    this.minimumRequirements,
    this.recommendedRequirements,
    this.languages,
    this.dlcIds = const [],
  });

  final String appId;
  final String name;
  final String? shortDescription;
  final List<String> genres;
  final List<String> features;
  final List<String> developers;
  final List<String> publishers;
  final String? releaseDate;
  final bool isComingSoon;
  final List<SteamScreenshot> screenshots;
  final String? trailerThumbnailUrl;
  final String? trailerName;
  final SteamPrice? price;
  final bool isFree;
  final String? minimumRequirements;
  final String? recommendedRequirements;
  final String? languages;
  final List<String> dlcIds;

  Uri get storeUrl => Uri.https('store.steampowered.com', '/app/$appId');

  @override
  List<Object?> get props => [appId, name, shortDescription, genres, features, developers, publishers, releaseDate, isComingSoon, screenshots, trailerThumbnailUrl, trailerName, price, isFree, minimumRequirements, recommendedRequirements, languages, dlcIds];
}

class SteamNews extends Equatable {
  const SteamNews({required this.title, required this.url, required this.publishedAt, this.feedLabel, this.snippet});

  final String title;
  final String url;
  final DateTime publishedAt;
  final String? feedLabel;
  final String? snippet;

  @override
  List<Object?> get props => [title, url, publishedAt, feedLabel, snippet];
}

class SteamDlc extends Equatable {
  const SteamDlc({required this.appId, required this.name, this.imageUrl, this.price, this.isFree = false, this.releaseDate, this.isComingSoon = false, this.isInCollection = false});

  final String appId;
  final String name;
  final String? imageUrl;
  final SteamPrice? price;
  final bool isFree;
  final String? releaseDate;
  final bool isComingSoon;
  final bool isInCollection;

  SteamDlc inCollection() => SteamDlc(appId: appId, name: name, imageUrl: imageUrl, price: price, isFree: isFree, releaseDate: releaseDate, isComingSoon: isComingSoon, isInCollection: true);

  @override
  List<Object?> get props => [appId, name, imageUrl, price, isFree, releaseDate, isComingSoon, isInCollection];
}

class SteamStoreSheet extends Equatable {
  const SteamStoreSheet({required this.page, this.news = const [], this.dlcs = const []});

  final SteamStorePage page;
  final List<SteamNews> news;
  final List<SteamDlc> dlcs;

  @override
  List<Object?> get props => [page, news, dlcs];
}
