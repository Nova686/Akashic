import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/console_case_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/console_case_style.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('known consoles get their case and unknown ones the generic case', () {
    expect(consoleCaseStyleFor('Nintendo Switch'), ConsoleCaseStyle.nintendoSwitch);
    expect(consoleCaseStyleFor('PlayStation 5'), ConsoleCaseStyle.playStation5);
    expect(consoleCaseStyleFor('PlayStation 4'), ConsoleCaseStyle.playStation4);
    expect(consoleCaseStyleFor('PlayStation 2'), ConsoleCaseStyle.playStation2);
    expect(consoleCaseStyleFor('Xbox Series X|S'), ConsoleCaseStyle.xbox);
    expect(consoleCaseStyleFor('Super Nintendo Entertainment System'), ConsoleCaseStyle.cardboardBox);
    expect(consoleCaseStyleFor('Game Boy Advance'), ConsoleCaseStyle.cartridge);
    expect(consoleCaseStyleFor('Nintendo 3DS'), ConsoleCaseStyle.handheld);
    expect(consoleCaseStyleFor('Neo Geo'), ConsoleCaseStyle.generic);
    expect(consoleCaseStyleFor(null), ConsoleCaseStyle.generic);
    expect(consoleCaseStyleFor(''), ConsoleCaseStyle.generic);
  });

  testWidgets('a console case spine never overflows with a long title', (tester) async {
    const item = CollectionItem(
      id: 'zelda',
      categoryId: 'games',
      titles: LocalizedTitles(byLanguage: {'en': 'The Legend of Zelda: Tears of the Kingdom'}),
      groupKey: 'Nintendo Switch',
    );
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: Center(child: ConsoleCaseSpine(item: item, label: 'The Legend of Zelda: Tears of the Kingdom', size: SpineSize.large))),
    ));
    expect(tester.takeException(), isNull);
    final size = tester.getSize(find.byType(ConsoleCaseSpine));
    expect(size.width, ConsoleCaseStyle.nintendoSwitch.width);
  });
}
