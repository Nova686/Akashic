import 'package:akashic/layers/functional/Settings/presentation/cubit/settings_cubit.dart';
import 'package:akashic/layers/functional/Settings/presentation/cubit/settings_state.dart';
import 'package:akashic/layers/functional/Settings/presentation/widgets/language_names.dart';
import 'package:akashic/layers/functional/Settings/presentation/widgets/language_section.dart';
import 'package:akashic/layers/technical/AppShell/app_version.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({this.onOpenImport, this.onOpenBackup, this.onOpenDiscogsImport, this.onOpenAccountImport, this.onReplayTutorial, this.apiLimitsSection, this.onExportSpreadsheet, this.highContrast, this.onHighContrastChanged, super.key});

  final VoidCallback? onOpenImport;
  final VoidCallback? onOpenBackup;
  final VoidCallback? onOpenDiscogsImport;
  final VoidCallback? onOpenAccountImport;
  final VoidCallback? onReplayTutorial;
  final Widget? apiLimitsSection;
  final VoidCallback? onExportSpreadsheet;
  final Stream<bool>? highContrast;
  final ValueChanged<bool>? onHighContrastChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.read<SettingsCubit>();
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) => current.lastLanguageRefused,
      listener: (context, state) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.lastLanguageRefused))),
      builder: (context, state) {
        final addableCodes = selectableTitleLanguageCodes.where((code) => !state.preferredLanguages.codes.contains(code)).toList();
        return Scaffold(
          appBar: AppBar(title: Text(l10n.settings, style: AkashicTypography.body(size: 18, weight: FontWeight.w700))),
          body: ListView(
            padding: safeListPadding(context),
            children: [
              _SectionTitle(l10n.appLanguage),
              AppLanguagePicker(selectedCode: state.appLanguageCode, onSelected: settings.chooseAppLanguage),
              _SectionTitle(l10n.preferredTitleLanguages),
              Text(l10n.preferredTitleLanguagesHint, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
              const SizedBox(height: 10),
              TitleLanguagesEditor(
                orderedCodes: state.preferredLanguages.codes,
                addableCodes: addableCodes,
                onMove: settings.moveLanguage,
                onRemove: settings.removeLanguage,
                onAdd: settings.addLanguage,
              ),
              if (onHighContrastChanged case final changeContrast?) ...[
                _SectionTitle(l10n.displaySection),
                StreamBuilder<bool>(
                  stream: highContrast,
                  builder: (context, contrast) => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.highContrast),
                    subtitle: Text(l10n.highContrastExplanation),
                    value: contrast.data ?? false,
                    onChanged: changeContrast,
                  ),
                ),
              ],
              if (onOpenImport != null || onOpenBackup != null) _SectionTitle(l10n.collectionData),
              if (onOpenBackup case final openBackup?)
                ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.cloud_outlined), title: Text(l10n.backup), onTap: openBackup),
              if (onOpenImport case final openImport?)
                ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.upload_file), title: Text(l10n.importCollection), onTap: openImport),
              if (onExportSpreadsheet case final exportSpreadsheet?)
                ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.table_view_outlined), title: Text(l10n.exportSpreadsheet), onTap: exportSpreadsheet),
              if (onOpenDiscogsImport case final openDiscogsImport?)
                ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.album_outlined), title: Text(l10n.discogsImportTitle), onTap: openDiscogsImport),
              if (onOpenAccountImport case final openAccountImport?)
                ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.link), title: Text(l10n.accountImportTitle), subtitle: Text(l10n.accountImportSubtitle), onTap: openAccountImport),
              if (apiLimitsSection case final limits?) ...[
                _SectionTitle(l10n.apiLimits),
                limits,
              ],
              if (onReplayTutorial case final replayTutorial?) ...[
                _SectionTitle(l10n.helpSection),
                ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.school_outlined), title: Text(l10n.replayTutorial), onTap: replayTutorial),
              ],
              _SectionTitle(l10n.dataSources),
              Text(l10n.dataSourcesList, style: AkashicTypography.body(size: 13)),
              const SizedBox(height: 8),
              Text(l10n.tmdbNotice, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
              const SizedBox(height: 20),
              Text(l10n.appVersionLabel(AppVersion.label), textAlign: TextAlign.center, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textFaint)),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(text, style: AkashicTypography.body(size: 15, weight: FontWeight.w700)),
    );
  }
}
