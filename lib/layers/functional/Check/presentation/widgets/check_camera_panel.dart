import 'dart:async';

import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/MediaStorage/silent_frame_capture.dart';
import 'package:akashic/layers/technical/Theme/akashic_animation.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

enum ScanMode { barcode, cover, shelf }

class CheckCameraPanel extends StatefulWidget {
  const CheckCameraPanel({required this.onBarcode, required this.onPhoto, this.onShelfPhoto, this.shutterBottomSpace = 96, super.key});

  final ValueChanged<String> onBarcode;
  final ValueChanged<Uint8List> onPhoto;
  final ValueChanged<Uint8List>? onShelfPhoto;
  final double shutterBottomSpace;

  @override
  State<CheckCameraPanel> createState() => _CheckCameraPanelState();
}

class _CheckCameraPanelState extends State<CheckCameraPanel> with WidgetsBindingObserver {
  static const Duration _analysisInterval = Duration(milliseconds: 180);

  final BarcodeScanner _barcodeScanner = BarcodeScanner(formats: const [BarcodeFormat.ean13, BarcodeFormat.ean8, BarcodeFormat.upca, BarcodeFormat.upce]);
  CameraController? _controller;
  CameraDescription? _camera;
  Future<void>? _opening;
  bool _isInBackground = false;
  bool _isUnavailable = false;
  bool _isCapturing = false;
  bool _isAnalyzing = false;
  DateTime _lastAnalysis = DateTime.fromMillisecondsSinceEpoch(0);
  ScanMode _mode = ScanMode.barcode;
  final NextFrameRequest _nextFrame = NextFrameRequest();
  bool _isFlashing = false;
  String? _lastBarcode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _openCamera();
  }

  bool _isCovered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isCovered = !TickerMode.valuesOf(context).enabled;
    if (isCovered == _isCovered) {
      return;
    }
    _isCovered = isCovered;
    if (isCovered) {
      _releaseCamera();
    } else if (!_isInBackground && _controller == null) {
      _openCamera();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.inactive) {
      _isInBackground = true;
      _releaseCamera();
    } else if (lifecycleState == AppLifecycleState.resumed) {
      _isInBackground = false;
      if (_controller == null && !_isCovered) {
        _openCamera();
      }
    }
  }

  void _openCamera() {
    _opening ??= _openBackCamera().whenComplete(() => _opening = null);
  }

  Future<void> _openBackCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _markUnavailable();
        return;
      }
      final backCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back, orElse: () => cameras.first);
      final controller = CameraController(backCamera, ResolutionPreset.veryHigh, enableAudio: false, imageFormatGroup: ImageFormatGroup.nv21);
      await controller.initialize();
      if (!mounted || _isInBackground || _isCovered) {
        await controller.dispose();
        return;
      }
      _camera = backCamera;
      setState(() {
        _controller = controller;
        _isUnavailable = false;
      });
      await _startBarcodeStream(controller);
    } on CameraException {
      _markUnavailable();
    }
  }

  Future<void> _startBarcodeStream(CameraController controller) async {
    if (!controller.value.isStreamingImages) {
      await controller.startImageStream(_analyzeFrame);
    }
  }

  Future<void> _analyzeFrame(CameraImage frame) async {
    final camera = _camera;
    if (camera != null && _nextFrame.serve(frame, rotationDegrees: camera.sensorOrientation)) {
      return;
    }
    final now = DateTime.now();
    if (camera == null || _mode != ScanMode.barcode || _isAnalyzing || _isCapturing || now.difference(_lastAnalysis) < _analysisInterval) {
      return;
    }
    final inputImage = _inputImageOf(frame, camera);
    if (inputImage == null) {
      return;
    }
    _isAnalyzing = true;
    _lastAnalysis = now;
    try {
      final barcodes = await _barcodeScanner.processImage(inputImage);
      final value = barcodes.map((barcode) => barcode.rawValue).nonNulls.firstOrNull;
      if (value != null && mounted && !_isCapturing) {
        if (value != _lastBarcode) {
          _lastBarcode = value;
          unawaited(HapticFeedback.mediumImpact());
        }
        widget.onBarcode(value);
      }
    } on Exception {
      return;
    } finally {
      _isAnalyzing = false;
    }
  }

  Future<String?> _barcodeIn(CapturedFrame frame) async {
    final rotation = InputImageRotationValue.fromRawValue(frame.rotationDegrees);
    if (rotation == null || frame.planes.isEmpty) {
      return null;
    }
    final bytes = frame.planes.length == 1 ? frame.planes.single.bytes : Uint8List.fromList([for (final plane in frame.planes) ...plane.bytes]);
    try {
      final barcodes = await _barcodeScanner.processImage(InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(size: Size(frame.width.toDouble(), frame.height.toDouble()), rotation: rotation, format: InputImageFormat.nv21, bytesPerRow: frame.planes.first.bytesPerRow),
      ));
      return barcodes.map((barcode) => barcode.rawValue).nonNulls.firstOrNull;
    } on Exception {
      return null;
    }
  }

  InputImage? _inputImageOf(CameraImage frame, CameraDescription camera) {
    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    final format = InputImageFormatValue.fromRawValue(frame.format.raw as int);
    if (rotation == null || format == null || frame.planes.isEmpty) {
      return null;
    }
    final bytes = frame.planes.length == 1 ? frame.planes.single.bytes : Uint8List.fromList([for (final plane in frame.planes) ...plane.bytes]);
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(size: Size(frame.width.toDouble(), frame.height.toDouble()), rotation: rotation, format: format, bytesPerRow: frame.planes.first.bytesPerRow),
    );
  }

  void _markUnavailable() {
    if (mounted) {
      setState(() => _isUnavailable = true);
    }
  }

  void _releaseCamera() {
    final controller = _controller;
    _controller = null;
    if (mounted) {
      setState(() {});
    }
    controller?.dispose();
  }

  Future<void> _shoot() => switch ((_mode, widget.onShelfPhoto)) {
        (ScanMode.shelf, final onShelfPhoto?) => _capture(onShelfPhoto),
        _ => _capture(widget.onPhoto),
      };

  Future<void> _capture(ValueChanged<Uint8List> onCaptured) async {
    final controller = _controller;
    if (controller == null || _isCapturing) {
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
      await _startBarcodeStream(controller);
      final frame = await sharpestFrame(_nextFrame);
      final barcode = _mode == ScanMode.cover ? await _barcodeIn(frame) : null;
      if (barcode != null) {
        unawaited(HapticFeedback.mediumImpact());
        widget.onBarcode(barcode);
        return;
      }
      onCaptured(await encodeFrameAsJpeg(frame));
    } on TimeoutException {
      _markUnavailable();
    } on CameraException {
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
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = _controller;
    if (_isUnavailable) {
      return ColoredBox(color: AkashicColors.night, child: Center(child: AkashicEmptyState(message: l10n.cameraUnavailable)));
    }
    if (controller == null || !controller.value.isInitialized) {
      return const ColoredBox(color: Colors.black, child: AkashicLoader());
    }
    final previewSize = controller.value.previewSize;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: Colors.black,
          child: ClipRect(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(width: previewSize?.height ?? 1, height: previewSize?.width ?? 1, child: CameraPreview(controller)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top + kToolbarHeight, bottom: widget.shutterBottomSpace + MediaQuery.paddingOf(context).bottom),
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => Center(child: _ScanFrame(mode: _mode, available: constraints.biggest)),
                ),
              ),
              const SizedBox(height: 12),
              _ScanHint(mode: _mode),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: _ScanModeSelector(
                    selected: _mode,
                    offersShelf: widget.onShelfPhoto != null,
                    onChanged: _isCapturing ? null : (mode) => setState(() => _mode = mode),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 76,
                child: Center(
                  child: _mode == ScanMode.barcode
                      ? _ContinuousReadingBadge(label: l10n.continuousReading)
                      : _ShutterButton(tooltip: _mode == ScanMode.shelf ? l10n.photographShelf : l10n.photographCover, isBusy: _isCapturing, onPressed: _shoot),
                ),
              ),
            ],
          ),
        ),
        IgnorePointer(
          child: AnimatedOpacity(
            opacity: _isFlashing ? 0.7 : 0,
            duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 120),
            child: const ColoredBox(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _ScanFrame extends StatelessWidget {
  const _ScanFrame({required this.mode, required this.available});

  final ScanMode mode;
  final Size available;

  @override
  Widget build(BuildContext context) {
    final roomHeight = (available.height - 24).clamp(80.0, double.infinity);
    final roomWidth = (available.width - 32).clamp(120.0, double.infinity);
    final coverHeight = roomHeight < 290.0 ? roomHeight : 290.0;
    final (width, height) = switch (mode) {
      ScanMode.barcode => (240.0, roomHeight < 120.0 ? roomHeight : 120.0),
      ScanMode.cover => (coverHeight * 0.76, coverHeight),
      ScanMode.shelf => (roomWidth, roomHeight < 300.0 ? roomHeight : 300.0),
    };
    return AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(border: Border.all(color: AkashicColors.lavender, width: 3), borderRadius: BorderRadius.circular(18)),
      child: mode == ScanMode.barcode ? const AkashicLottie(AkashicAnimation.scanSweep, size: 120, width: 240, fit: BoxFit.fill) : null,
    );
  }
}

class _ScanHint extends StatelessWidget {
  const _ScanHint({required this.mode});

  final ScanMode mode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (title, detail) = switch (mode) {
      ScanMode.barcode => (l10n.scanHintBarcodeTitle, l10n.scanHintBarcodeDetail),
      ScanMode.cover => (l10n.scanHintCoverTitle, l10n.scanHintCoverDetail),
      ScanMode.shelf => (l10n.scanHintShelfTitle, l10n.scanHintShelfDetail),
    };
    const shadow = [Shadow(blurRadius: 8)];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: AkashicTypography.body(size: 16, weight: FontWeight.w700).copyWith(color: Colors.white, shadows: shadow)),
          Text(detail, textAlign: TextAlign.center, style: AkashicTypography.body(size: 13).copyWith(color: Colors.white.withValues(alpha: 0.8), shadows: shadow)),
        ],
      ),
    );
  }
}

class _ScanModeSelector extends StatelessWidget {
  const _ScanModeSelector({required this.selected, required this.offersShelf, required this.onChanged});

  final ScanMode selected;
  final bool offersShelf;
  final ValueChanged<ScanMode>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final modes = [
      (ScanMode.barcode, Icons.qr_code_scanner, l10n.scanModeBarcode),
      (ScanMode.cover, Icons.photo_camera_outlined, l10n.scanModeCover),
      if (offersShelf) (ScanMode.shelf, Icons.shelves, l10n.scanModeShelf),
    ];
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(28),
      child: Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (mode, icon, label) in modes)
            Semantics(
              button: true,
              selected: mode == selected,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: onChanged == null ? null : () => onChanged!(mode),
                child: AnimatedContainer(
                  duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 160),
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: mode == selected ? AkashicColors.lavender : Colors.transparent, borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 18, color: mode == selected ? AkashicColors.night : Colors.white),
                      const SizedBox(width: 6),
                      Text(label, style: AkashicTypography.body(size: 13, weight: FontWeight.w700).copyWith(color: mode == selected ? AkashicColors.night : Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }
}

class _ContinuousReadingBadge extends StatelessWidget {
  const _ContinuousReadingBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(20), border: Border.all(color: AkashicColors.teal.withValues(alpha: 0.6))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AkashicColors.teal, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: AkashicTypography.body(size: 13, weight: FontWeight.w600).copyWith(color: Colors.white)),
          ],
        ),
      );
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.tooltip, required this.isBusy, required this.onPressed});

  final String tooltip;
  final bool isBusy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: GestureDetector(
          onTap: isBusy ? null : onPressed,
          child: AnimatedContainer(
            duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 150),
            width: 76,
            height: 76,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
            child: DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, color: isBusy ? AkashicColors.lavender.withValues(alpha: 0.5) : AkashicColors.lavender),
              child: const Icon(Icons.photo_camera, color: AkashicColors.night),
            ),
          ),
        ),
      ),
    );
  }
}
