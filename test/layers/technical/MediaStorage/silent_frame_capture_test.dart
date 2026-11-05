import 'dart:typed_data';

import 'package:akashic/layers/technical/MediaStorage/silent_frame_capture.dart';
import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

CameraImage nv21Frame({required int width, required int height, required int luma, required int v, required int u}) {
  final bytes = Uint8List(width * height * 3 ~/ 2)..fillRange(0, width * height, luma);
  for (var index = width * height; index < bytes.length; index += 2) {
    bytes[index] = v;
    bytes[index + 1] = u;
  }
  return CameraImage.fromPlatformInterface(CameraImageData(
    format: const CameraImageFormat(ImageFormatGroup.nv21, raw: 17),
    width: width,
    height: height,
    planes: [CameraImagePlane(bytes: bytes, bytesPerRow: width, bytesPerPixel: 1)],
  ));
}

void main() {
  test('a stream frame is turned into an upright colour picture without any shutter', () {
    final frame = captureFrame(nv21Frame(width: 4, height: 2, luma: 81, v: 240, u: 90), rotationDegrees: 90);
    final picture = imageOfFrame(frame);
    expect((picture.width, picture.height), (2, 4));
    final pixel = picture.getPixel(0, 0);
    expect(pixel.r, greaterThan(200));
    expect(pixel.g, lessThan(60));
    expect(pixel.b, lessThan(60));
  });

  test('a grey frame stays grey and a picture is encoded as jpeg within the maximum side', () async {
    final picture = imageOfFrame(captureFrame(nv21Frame(width: 4, height: 4, luma: 128, v: 128, u: 128), rotationDegrees: 0));
    expect((picture.getPixel(1, 1).r, picture.getPixel(1, 1).g, picture.getPixel(1, 1).b), (128, 128, 128));
    final jpeg = await encodeFrameAsJpeg(captureFrame(nv21Frame(width: 40, height: 20, luma: 128, v: 128, u: 128), rotationDegrees: 0), maximumSide: 10);
    final decoded = img.decodeJpg(jpeg)!;
    expect((decoded.width, decoded.height), (10, 5));
  });

  test('the next frame request is served by the following stream frame only once', () async {
    final request = NextFrameRequest();
    expect(request.serve(nv21Frame(width: 2, height: 2, luma: 0, v: 128, u: 128), rotationDegrees: 0), isFalse);
    final next = request.next();
    expect(request.isWaiting, isTrue);
    expect(request.serve(nv21Frame(width: 2, height: 2, luma: 10, v: 128, u: 128), rotationDegrees: 90), isTrue);
    expect((await next).rotationDegrees, 90);
    expect(request.isWaiting, isFalse);
  });
}
