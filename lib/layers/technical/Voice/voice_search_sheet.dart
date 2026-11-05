import 'dart:async';

import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

typedef HeardWords = ({String words, bool isFinal});

abstract interface class VoiceListener {
  Future<bool> start({required String localeId, required void Function(HeardWords heard) onHeard, required VoidCallback onDone});
  Future<void> stop();
}

class SpeechVoiceListener implements VoiceListener {
  SpeechVoiceListener({SpeechToText? speech}) : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;
  VoidCallback? _onDone;

  @override
  Future<bool> start({required String localeId, required void Function(HeardWords heard) onHeard, required VoidCallback onDone}) async {
    _onDone = onDone;
    final isReady = await _speech.initialize(
      onStatus: (status) {
        if (status == SpeechToText.doneStatus || status == SpeechToText.notListeningStatus) {
          _onDone?.call();
        }
      },
      onError: (_) => _onDone?.call(),
    );
    if (!isReady) {
      return false;
    }
    await _speech.listen(
      onResult: (SpeechRecognitionResult result) => onHeard((words: result.recognizedWords, isFinal: result.finalResult)),
      listenOptions: SpeechListenOptions(localeId: localeId, partialResults: true, listenFor: const Duration(seconds: 20), pauseFor: const Duration(seconds: 3)),
    );
    return true;
  }

  @override
  Future<void> stop() => _speech.stop();
}

Future<String?> listenForSearch(BuildContext context, VoiceListener listener) => showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => _VoiceSheet(listener: listener),
    );

class _VoiceSheet extends StatefulWidget {
  const _VoiceSheet({required this.listener});

  final VoiceListener listener;

  @override
  State<_VoiceSheet> createState() => _VoiceSheetState();
}

class _VoiceSheetState extends State<_VoiceSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  String _words = '';
  bool _isListening = false;
  bool _isUnavailable = false;
  bool _hasFinished = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    final locale = Localizations.localeOf(context);
    if (!MediaQuery.disableAnimationsOf(context)) {
      unawaited(_pulse.repeat(reverse: true));
    }
    final started = await widget.listener.start(
      localeId: locale.toLanguageTag().replaceAll('-', '_'),
      onHeard: (heard) {
        if (!mounted) {
          return;
        }
        setState(() => _words = heard.words);
        if (heard.isFinal && heard.words.trim().isNotEmpty && !_hasFinished) {
          _hasFinished = true;
          Navigator.of(context).pop(heard.words.trim());
        }
      },
      onDone: () {
        if (mounted) {
          _pulse.stop();
          setState(() => _isListening = false);
        }
      },
    );
    if (mounted) {
      setState(() {
        _isListening = started;
        _isUnavailable = !started;
      });
      if (!started) {
        _pulse.stop();
      }
    }
  }

  @override
  void dispose() {
    widget.listener.stop();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_isUnavailable ? l10n.voiceUnavailable : (_isListening ? l10n.voiceListening : l10n.voiceTapToRetry), style: AkashicTypography.body(size: 15, weight: FontWeight.w700)),
            const SizedBox(height: 18),
            Semantics(
              button: true,
              label: _isListening ? l10n.voiceStop : l10n.voiceTapToRetry,
              excludeSemantics: true,
              onTap: _isListening ? widget.listener.stop : _start,
              child: GestureDetector(
                onTap: _isListening ? widget.listener.stop : _start,
                child: AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, child) => Container(
                    width: 88 + 16 * _pulse.value,
                    height: 88 + 16 * _pulse.value,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AkashicColors.teal.withValues(alpha: 0.15 + 0.15 * _pulse.value)),
                    alignment: Alignment.center,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AkashicColors.teal),
                      child: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 34, color: AkashicColors.night),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Semantics(
              liveRegion: true,
              child: Text(
                _words.isEmpty ? l10n.voiceHint : _words,
                textAlign: TextAlign.center,
                style: AkashicTypography.displayTitle(size: 22).copyWith(color: _words.isEmpty ? AkashicColors.textSoft : AkashicColors.text),
              ),
            ),
            const SizedBox(height: 14),
            if (_words.trim().isNotEmpty && !_isListening) FilledButton(onPressed: () => Navigator.of(context).pop(_words.trim()), child: Text(l10n.voiceUseWords)),
          ],
        ),
      ),
    );
  }
}
