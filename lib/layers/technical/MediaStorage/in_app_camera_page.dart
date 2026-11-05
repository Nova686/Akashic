import 'dart:async';
import 'dart:typed_data';

import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/MediaStorage/silent_frame_capture.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/system_navigation_band.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class InAppCameraPage extends StatefulWidget {
  const InAppCameraPage({this.maximumSide = 1200, super.key});

  final int maximumSide;

  @override
  State<InAppCameraPage> createState() => _InAppCameraPageState();
}

class _InAppCameraPageState extends State<InAppCameraPage> with WidgetsBindingObserver {
  final NextFrameRequest _nextFrame = NextFrameRequest();
  CameraController? _controller;
  CameraDescription? _camera;
  bool _isUnavailable = false;
  bool _isCapturing = false;
  bool _isFlashing = false;

  Future<void>? _opening;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _openOnce();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.inactive) {
      final controller = _controller;
      _controller = null;
      if (mounted) {
        setState(() {});
      }
      controller?.dispose();
    } else if (lifecycleState == AppLifecycleState.resumed && _controller == null) {
      _openOnce();
    }
  }

  void _openOnce() {
    _opening ??= _open().whenComplete(() => _opening = null);
  }

  Future<void> _open() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _markUnavailable();
        return;
      }
      final camera = cameras.firstWhere((candidate) => candidate.lensDirection == CameraLensDirection.back, orElse: () => cameras.first);
      final controller = CameraController(camera, ResolutionPreset.veryHigh, enableAudio: false, imageFormatGroup: ImageFormatGroup.nv21);
      await controller.initialize();
      if (mounted) {
        await controller.startImageStream((frame) => _nextFrame.serve(frame, rotationDegrees: camera.sensorOrientation));
      }
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _camera = camera;
        _controller = controller;
        _isUnavailable = false;
      });
    } on CameraException {
      _markUnavailable();
    }
  }

  void _markUnavailable() {
    if (mounted) {
      setState(() => _isUnavailable = true);
    }
  }

  Future<void> _shoot() async {
    if (_isCapturing || _camera == null) {
      return;
    }
    setState(() {
      _isCapturing = true;
      _isFlashing = true;
    });
    Future<void>.delayed(const Duration(milliseconds: 140), () {
      if (mounted) {
        setState(() => _isFlashing = false);
      }
    });
    try {
      final photo = await encodeFrameAsJpeg(await _nextFrame.next(), maximumSide: widget.maximumSide);
      if (mounted) {
        Navigator.of(context).pop<Uint8List>(photo);
      }
    } on TimeoutException {
      _markUnavailable();
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = _controller;
    final previewSize = controller?.value.previewSize;
    return ImmersiveSystemBars(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.transparent, foregroundColor: Colors.white, leading: IconButton(tooltip: l10n.close, icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop())),
        body: _isUnavailable
            ? ColoredBox(color: AkashicColors.night, child: Center(child: AkashicEmptyState(message: l10n.cameraUnavailable)))
            : controller == null || !controller.value.isInitialized
                ? const ColoredBox(color: Colors.black, child: AkashicLoader())
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRect(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(width: previewSize?.height ?? 1, height: previewSize?.width ?? 1, child: CameraPreview(controller)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 32 + MediaQuery.paddingOf(context).bottom),
                          child: Semantics(
                            button: true,
                            label: l10n.takePhoto,
                            child: GestureDetector(
                              onTap: _isCapturing ? null : _shoot,
                              child: Container(
                                width: 76,
                                height: 76,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: _isCapturing ? AkashicColors.lavender.withValues(alpha: 0.5) : AkashicColors.lavender),
                                  child: const Icon(Icons.photo_camera, color: AkashicColors.night),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IgnorePointer(
                        child: AnimatedOpacity(opacity: _isFlashing ? 0.7 : 0, duration: const Duration(milliseconds: 120), child: const ColoredBox(color: Colors.white)),
                      ),
                    ],
                  ),
      ),
    );
  }
}
