import 'dart:async';

import 'package:akashic/layers/functional/Check/presentation/widgets/check_camera_panel.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class PermissionAskingCamera extends CameraPlatform with MockPlatformInterfaceMixin {
  final Completer<void> permissionAnswer = Completer<void>();
  final StreamController<CameraInitializedEvent> initializedEvents = StreamController<CameraInitializedEvent>.broadcast();
  int createdCameras = 0;
  int disposedCameras = 0;

  @override
  Future<List<CameraDescription>> availableCameras() async =>
      const [CameraDescription(name: 'back', lensDirection: CameraLensDirection.back, sensorOrientation: 90)];

  @override
  Future<int> createCameraWithSettings(CameraDescription cameraDescription, MediaSettings? mediaSettings) async {
    createdCameras++;
    await permissionAnswer.future;
    return createdCameras;
  }

  @override
  Stream<DeviceOrientationChangedEvent> onDeviceOrientationChanged() => const Stream.empty();

  @override
  Stream<CameraInitializedEvent> onCameraInitialized(int cameraId) => initializedEvents.stream.where((event) => event.cameraId == cameraId);

  @override
  Stream<CameraErrorEvent> onCameraError(int cameraId) => StreamController<CameraErrorEvent>().stream;

  @override
  bool supportsImageStreaming() => true;

  @override
  Future<void> initializeCamera(int cameraId, {ImageFormatGroup imageFormatGroup = ImageFormatGroup.unknown}) async {
    scheduleMicrotask(() => initializedEvents.add(CameraInitializedEvent(cameraId, 640, 480, ExposureMode.auto, false, FocusMode.auto, false)));
  }

  @override
  Stream<CameraImageData> onStreamedFrameAvailable(int cameraId, {CameraImageStreamOptions? options}) => StreamController<CameraImageData>().stream;

  @override
  Widget buildPreview(int cameraId) => const SizedBox.expand();

  @override
  Future<void> dispose(int cameraId) async => disposedCameras++;
}

void main() {
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('google_mlkit_barcode_scanning'), (call) async => null);
  });

  testWidgets('the permission prompt pausing the app never opens the camera a second time', (tester) async {
    final camera = PermissionAskingCamera();
    CameraPlatform.instance = camera;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CheckCameraPanel(onBarcode: (_) {}, onPhoto: (_) {}),
    ));
    await tester.pump();
    expect(camera.createdCameras, 1);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    camera.permissionAnswer.complete();
    await tester.pump();
    await tester.pump();
    expect(camera.createdCameras, 1);
    expect(camera.disposedCameras, 0);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('a camera opened while the app is away is released, then opened again on return', (tester) async {
    final camera = PermissionAskingCamera();
    CameraPlatform.instance = camera;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CheckCameraPanel(onBarcode: (_) {}, onPhoto: (_) {}),
    ));
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    camera.permissionAnswer.complete();
    await tester.pump();
    await tester.pump();
    expect(camera.disposedCameras, 1);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();
    expect(camera.createdCameras, 2);
    expect(camera.disposedCameras, 1);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
