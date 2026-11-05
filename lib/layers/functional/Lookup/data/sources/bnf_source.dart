import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/google_books_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_registry.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/volume_title.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class BnfSource implements CatalogSource {
  BnfSource(this._client);

  static const String sourceKey = 'bnf';
  static const Set<String> comicPublishers = {
    'dargaud', 'dupuis', 'casterman', 'glénat', 'delcourt', 'soleil', 'le lombard', 'lombard', 'futuropolis', 'rue de sèvres', 'bamboo',
    'albert rené', 'éditions albert rené', 'les humanoïdes associés', 'fluide glacial', 'blake et mortimer', 'éditions blake et mortimer', 'marsu productions',
  };
  static const Set<String> _translatorRoles = {'traducteur', 'traductrice', 'translator'};

  final http.Client _client;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.books, CategoryType.comics, CategoryType.manga};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => true;

  @override
  Future<List<SourceMatch>> search(String query) async => const [];

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async {
    if (!isIsbn13(barcode)) {
      return const [];
    }
    final response = await sourceGetText(
      _client,
      Uri.https('catalogue.bnf.fr', '/api/SRU', {
        'version': '1.2',
        'operation': 'searchRetrieve',
        'query': 'bib.isbn all "$barcode"',
        'recordSchema': 'dublincore',
        'maximumRecords': '2',
      }),
      sourceKey: key,
    );
    final XmlDocument document;
    try {
      document = XmlDocument.parse(response ?? '');
    } on XmlException {
      throw const SourceUnavailable(sourceKey, 'unreadable answer');
    }
    return [
      for (final record in document.findAllElements('dc', namespaceUri: '*')) ?_matchOf(record, barcode),
    ].take(1).toList();
  }

  SourceMatch? _matchOf(XmlElement record, String barcode) {
    List<String> values(String field) => [
          for (final element in record.findElements(field, namespaceUri: '*'))
            if (element.innerText.trim() case final text when text.isNotEmpty) text,
        ];
    final rawTitle = values('title').firstOrNull;
    final ark = values('identifier').map((identifier) => RegExp(r'ark:/12148/[a-z0-9]+').firstMatch(identifier)?.group(0)).nonNulls.firstOrNull;
    if (rawTitle == null || ark == null) {
      return null;
    }
    final title = cleanBnfTitle(rawTitle);
    final publisher = values('publisher').map(cleanBnfPublisher).firstOrNull;
    final type = _typeOf(publisher, values('format').join(' '));
    final numbered = type == CategoryType.books ? null : parseVolumeTitle(title);
    return SourceMatch(
      sourceKey: key,
      externalWorkId: ark,
      externalEditionId: ark,
      titles: LocalizedTitles(byLanguage: {'fr': title}),
      creator: values('creator').map(bnfPersonName).nonNulls.firstOrNull,
      year: int.tryParse(RegExp(r'\d{4}').firstMatch(values('date').firstOrNull ?? '')?.group(0) ?? ''),
      publisher: publisher,
      barcode: barcode,
      imageUrl: 'https://catalogue.bnf.fr/couverture?appName=NE&idArk=$ark&couverture=1',
      seriesTitle: numbered?.seriesTitle,
      volumeNumber: numbered?.volumeNumber,
      suggestedType: type,
    );
  }

  CategoryType _typeOf(String? publisher, String format) {
    final normalized = publisher == null ? null : GoogleBooksSource.normalizedPublisher(publisher);
    if (publisher != null && GoogleBooksSource.isMangaPublisher(publisher)) {
      return CategoryType.manga;
    }
    if ((normalized != null && comicPublishers.contains(normalized)) || format.contains('tout en ill.')) {
      return CategoryType.comics;
    }
    return CategoryType.books;
  }

  static String? bnfPersonName(String raw) {
    final roles = RegExp(r'\(([^)]*)\)').allMatches(raw).map((match) => match.group(1)!.toLowerCase());
    if (roles.any(_translatorRoles.contains) || RegExp(r'\.\s*Traduct', caseSensitive: false).hasMatch(raw)) {
      return null;
    }
    final withoutNotes = raw.replaceAll(RegExp(r'\s*\([^)]*\)'), '').replaceAll(RegExp(r'\.\s+[A-ZÉ][^,]*$'), '').trim();
    final parts = withoutNotes.split(',').map((part) => part.trim()).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) {
      return null;
    }
    return parts.length >= 2 ? '${parts[1]} ${parts[0]}' : parts.first;
  }
}

String cleanBnfTitle(String raw) => raw.split(' / ').first.replaceAll(RegExp(r'\s*\[[^\]]*\]'), '').trim();

String cleanBnfPublisher(String raw) => raw.replaceAll(RegExp(r'\s*\([^)]*\)\s*$'), '').trim();
