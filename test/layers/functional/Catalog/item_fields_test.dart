import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/item_field.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('music categories have no series field', () {
    expect(CategoryType.music.itemFields, [ItemField.creator, ItemField.year, ItemField.publisher]);
    expect(CategoryType.music.itemFields, isNot(contains(ItemField.series)));
  });

  test('printed categories have series and video games have a platform', () {
    expect(CategoryType.manga.itemFields, contains(ItemField.series));
    expect(CategoryType.books.itemFields, contains(ItemField.series));
    expect(CategoryType.videoGames.itemFields, [ItemField.creator, ItemField.year, ItemField.platform]);
    expect(CategoryType.cards.itemFields, [ItemField.year, ItemField.publisher]);
    expect(CategoryType.films.itemFields, [ItemField.creator, ItemField.year]);
  });
}
