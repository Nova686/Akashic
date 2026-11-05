import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_copy.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/copy_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/copy_editor_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateCopy extends Mock implements UpdateCopy {}

void main() {
  late MockUpdateCopy updateCopy;

  setUpAll(() => registerFallbackValue(const ItemCopy(id: 'fallback', itemId: 'fallback')));

  setUp(() {
    updateCopy = MockUpdateCopy();
    when(() => updateCopy(any())).thenAnswer((_) async {});
  });

  test('invalid price emits a field error and does not save', () async {
    final editor = CopyEditorCubit(updateCopy, const ItemCopy(id: 'copy', itemId: 'kob'), parts: const ['Disque', 'Pochette']);
    editor.setPriceText('vingt euros');
    await editor.save();
    expect(editor.state.priceError, isTrue);
    expect(editor.state.status, CopyEditorStatus.editing);
    verifyNever(() => updateCopy(any()));
    await editor.close();
  });

  test('saving keeps edition, price in cents, location and conditions per part', () async {
    final editor = CopyEditorCubit(updateCopy, const ItemCopy(id: 'copy', itemId: 'kob'), parts: const ['Disque', 'Pochette']);
    editor
      ..setEdition('Réédition 2015, 180 g')
      ..setPriceText('28,50')
      ..setLocation('Bac 2, salon')
      ..setCondition('Disque', ItemCondition.veryGood)
      ..setCondition('Pochette', ItemCondition.missing);
    await editor.save();
    final saved = verify(() => updateCopy(captureAny())).captured.single as ItemCopy;
    expect(saved.pricePaidCents, 2850);
    expect(saved.conditions, {'Disque': ItemCondition.veryGood, 'Pochette': ItemCondition.missing});
    expect(saved.location, 'Bac 2, salon');
    expect(editor.state.status, CopyEditorStatus.saved);
    await editor.close();
  });

  test('saving a lent copy keeps its loan, barcode and source edition', () async {
    final lentCopy = ItemCopy(id: 'copy', itemId: 'kob', barcode: '4547366033267', externalEditionId: 'release-2007', loanedTo: 'Camille', loanedSince: DateTime(2026, 10, 1));
    final editor = CopyEditorCubit(updateCopy, lentCopy, parts: const ['Disque']);
    editor.setPriceText('20');
    await editor.save();
    final saved = verify(() => updateCopy(captureAny())).captured.single as ItemCopy;
    expect(saved.loanedTo, 'Camille');
    expect(saved.loanedSince, DateTime(2026, 10, 1));
    expect(saved.barcode, '4547366033267');
    expect(saved.externalEditionId, 'release-2007');
    expect(saved.pricePaidCents, 2000);
    await editor.close();
  });
}
