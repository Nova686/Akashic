import 'package:equatable/equatable.dart';

enum TextKind { summary }

enum FactKind { label, status, volumes, chapters, runtime, director, studio, platforms, pages, publisher, format }

class DetailTrack extends Equatable {
  const DetailTrack({required this.position, required this.title, this.duration});

  final String position;
  final String title;
  final String? duration;

  @override
  List<Object?> get props => [position, title, duration];
}

class DetailLink extends Equatable {
  const DetailLink({required this.label, required this.url});

  final String label;
  final String url;

  @override
  List<Object?> get props => [label, url];
}

class DetailFact extends Equatable {
  const DetailFact({required this.kind, required this.value});

  final FactKind kind;
  final String value;

  @override
  List<Object?> get props => [kind, value];
}

sealed class DetailSection extends Equatable {
  const DetailSection();

  bool get isEmpty;
}

class TextSection extends DetailSection {
  const TextSection({required this.kind, required this.text, required this.sourceLabel});

  final TextKind kind;
  final String text;
  final String sourceLabel;

  @override
  bool get isEmpty => text.trim().isEmpty;

  @override
  List<Object?> get props => [kind, text, sourceLabel];
}

class TrackListSection extends DetailSection {
  const TrackListSection({required this.tracks, required this.sourceLabel});

  final List<DetailTrack> tracks;
  final String sourceLabel;

  @override
  bool get isEmpty => tracks.isEmpty;

  @override
  List<Object?> get props => [tracks, sourceLabel];
}

class TagSection extends DetailSection {
  const TagSection({required this.tags});

  final List<String> tags;

  @override
  bool get isEmpty => tags.isEmpty;

  @override
  List<Object?> get props => [tags];
}

class LinkSection extends DetailSection {
  const LinkSection({required this.links});

  final List<DetailLink> links;

  @override
  bool get isEmpty => links.isEmpty;

  @override
  List<Object?> get props => [links];
}

class FactsSection extends DetailSection {
  const FactsSection({required this.facts, required this.sourceLabel});

  final List<DetailFact> facts;
  final String sourceLabel;

  @override
  bool get isEmpty => facts.isEmpty;

  @override
  List<Object?> get props => [facts, sourceLabel];
}

class ItemDetails extends Equatable {
  const ItemDetails({required this.sections, required this.fetchedAt});

  final List<DetailSection> sections;
  final DateTime fetchedAt;

  @override
  List<Object?> get props => [sections, fetchedAt];
}
