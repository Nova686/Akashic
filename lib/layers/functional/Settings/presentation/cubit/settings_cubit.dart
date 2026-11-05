import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_app_language.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/presentation/cubit/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._preferredLanguages, this._appLanguage) : super(const SettingsState.initial());

  final ManagePreferredLanguages _preferredLanguages;
  final ManageAppLanguage _appLanguage;

  Future<void> load() async {
    emit(state.copyWith(
      preferredLanguages: await _preferredLanguages.current(),
      appLanguageCode: () => null,
    ));
    final appLanguageCode = await _appLanguage.watch().first;
    emit(state.copyWith(appLanguageCode: () => appLanguageCode));
  }

  Future<void> addLanguage(String code) async => emit(state.copyWith(preferredLanguages: await _preferredLanguages.add(code)));

  Future<void> moveLanguage(int from, int to) async => emit(state.copyWith(preferredLanguages: await _preferredLanguages.move(from, to)));

  Future<void> removeLanguage(String code) async {
    try {
      emit(state.copyWith(preferredLanguages: await _preferredLanguages.remove(code)));
    } on LastPreferredLanguage {
      emit(state.copyWith(lastLanguageRefused: true));
    }
  }

  Future<void> chooseAppLanguage(String? languageCode) async {
    await _appLanguage.choose(languageCode);
    emit(state.copyWith(appLanguageCode: () => languageCode));
  }
}
