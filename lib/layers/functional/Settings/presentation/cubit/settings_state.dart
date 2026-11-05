import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  const SettingsState({required this.preferredLanguages, required this.appLanguageCode, required this.lastLanguageRefused});

  const SettingsState.initial()
      : preferredLanguages = PreferredLanguages.defaults,
        appLanguageCode = null,
        lastLanguageRefused = false;

  final PreferredLanguages preferredLanguages;
  final String? appLanguageCode;
  final bool lastLanguageRefused;

  SettingsState copyWith({PreferredLanguages? preferredLanguages, String? Function()? appLanguageCode, bool? lastLanguageRefused}) {
    return SettingsState(
      preferredLanguages: preferredLanguages ?? this.preferredLanguages,
      appLanguageCode: appLanguageCode == null ? this.appLanguageCode : appLanguageCode(),
      lastLanguageRefused: lastLanguageRefused ?? false,
    );
  }

  @override
  List<Object?> get props => [preferredLanguages, appLanguageCode, lastLanguageRefused];
}
