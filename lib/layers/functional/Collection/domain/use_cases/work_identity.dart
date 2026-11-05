import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';

String workIdentityOf(String title, String? creator) => 'work|${normalizeForSearch(title)}|${normalizeForSearch(creator ?? '')}';

String titleIdentityOf(String title) => 'title|${normalizeForSearch(title)}';
