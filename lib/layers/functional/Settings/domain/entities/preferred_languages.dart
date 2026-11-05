import 'package:equatable/equatable.dart';

class LastPreferredLanguage implements Exception {
  const LastPreferredLanguage();
}

class PreferredLanguages extends Equatable {
  const PreferredLanguages(this.codes);

  static const PreferredLanguages defaults = PreferredLanguages(['fr', 'en']);

  final List<String> codes;

  PreferredLanguages add(String code) => codes.contains(code) ? this : PreferredLanguages([...codes, code]);

  PreferredLanguages remove(String code) {
    if (codes.length == 1 && codes.contains(code)) {
      throw const LastPreferredLanguage();
    }
    return PreferredLanguages(codes.where((existing) => existing != code).toList());
  }

  PreferredLanguages move(int from, int to) {
    final reordered = [...codes];
    final moved = reordered.removeAt(from);
    reordered.insert(to.clamp(0, reordered.length), moved);
    return PreferredLanguages(reordered);
  }

  @override
  List<Object?> get props => [codes];
}
