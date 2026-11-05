import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/suggest_category.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_cubit.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_state.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/cover_text_lines.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/cover_text_reader.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckOwnership extends Mock implements CheckOwnership {}

class MockAddFromMatch extends Mock implements AddFromMatch {}

class MockSuggestCategory extends Mock implements SuggestCategory {}

class SilentReader implements CoverTextReader {
  @override
  Future<List<CoverTextLine>> readLines(Uint8List image) async => const [];
}

class NoPicker implements PhoneImagePicker {
  @override
  Future<Uint8List?> pickFromGallery() async => null;

  @override
  Future<Uint8List?> takePhoto() async => null;
}

void main() {
  late MockCheckOwnership checkOwnership;
  late MockAddFromMatch addFromMatch;
  late MockSuggestCategory suggestCategory;

  setUpAll(() {
    registerFallbackValue(CategoryType.music);
    registerFallbackValue(const SourceMatch(sourceKey: 'mb', externalWorkId: 'fallback', titles: LocalizedTitles(byLanguage: {}), suggestedType: CategoryType.music));
  });

  setUp(() {
    checkOwnership = MockCheckOwnership();
    addFromMatch = MockAddFromMatch();
    suggestCategory = MockSuggestCategory();
    when(() => suggestCategory.forMatch(any())).thenAnswer((_) async => null);
  });

  test('a failing entry in a chain scan does not block the next ones', () async {
    when(() => checkOwnership.barcode('0000000000001')).thenThrow(const FormatException('html'));
    when(() => checkOwnership.barcode('0000000000002')).thenAnswer(
      (_) async => const NotOwned(SourceMatch(sourceKey: 'mb', externalWorkId: 'x', titles: LocalizedTitles(byLanguage: {'en': 'X'}), suggestedType: CategoryType.music), '0000000000002'),
    );
    final cubit = ChainScanCubit(checkOwnership, addFromMatch, suggestCategory)
      ..scan('0000000000001')
      ..scan('0000000000002');
    await cubit.whenIdle();
    expect(cubit.state.entries.map((entry) => entry.status), [ChainEntryStatus.unreachable, ChainEntryStatus.found]);
    await cubit.close();
  });

  test('leaving a chain scan while it commits does not throw', () async {
    when(() => checkOwnership.barcode('0000000000002')).thenAnswer(
      (_) async => const NotOwned(SourceMatch(sourceKey: 'mb', externalWorkId: 'x', titles: LocalizedTitles(byLanguage: {'en': 'X'}), suggestedType: CategoryType.music), '0000000000002'),
    );
    final cubit = ChainScanCubit(checkOwnership, addFromMatch, suggestCategory)..scan('0000000000002');
    await cubit.whenIdle();
    final closing = cubit.close();
    await expectLater(cubit.commit(), completes);
    await closing;
  });
}
