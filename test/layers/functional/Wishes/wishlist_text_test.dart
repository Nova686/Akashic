import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Wishes/presentation/widgets/wishlist_text.dart';
import 'package:akashic/layers/technical/Localization/app_localizations_fr.dart';
import 'package:flutter_test/flutter_test.dart';

Wish wishOf(String title, CategoryType type, {String? creator}) => Wish(
      id: title,
      createdAt: DateTime(2026, 10, 28),
      draft: WishDraft(categoryType: type, title: title, creator: creator, key: WishKey(barcode: title), origin: WishOrigin.manual),
    );

void main() {
  test('the shared wish list is grouped by type, sorted, with the authors', () {
    final text = wishlistText([
      wishOf('Vagabond', CategoryType.manga, creator: 'Takehiko Inoue'),
      wishOf('Blue Train', CategoryType.music, creator: 'John Coltrane'),
      wishOf('Berserk', CategoryType.manga),
    ], AppLocalizationsFr());
    expect(text, 'Mes envies, depuis Akashic\n\nMusique\n• Blue Train — John Coltrane\n\nMangas\n• Berserk\n• Vagabond — Takehiko Inoue');
  });
}
