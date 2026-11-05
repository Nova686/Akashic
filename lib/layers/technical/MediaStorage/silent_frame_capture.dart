import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class CapturedPlane {
  const CapturedPlane({required this.bytes, required this.bytesPerRow, this.bytesPerPixel});

  final Uint8List bytes;
  final int bytesPerRow;
  final int? bytesPerPixel;
}

class CapturedFrame {
  const CapturedFrame({required this.planes, required this.width, required this.height, required this.rotationDegrees});

  final List<CapturedPlane> planes;
  final int width;
  final int height;
  final int rotationDegrees;
}

CapturedFrame captureFrame(CameraImage frame, {required int rotationDegrees}) => CapturedFrame(
      planes: [for (final plane in frame.planes) CapturedPlane(bytes: Uint8List.fromList(plane.bytes), bytesPerRow: plane.bytesPerRow, bytesPerPixel: plane.bytesPerPixel)],
      width: frame.width,
      height: frame.height,
      rotationDegrees: rotationDegrees,
    );

int _clamp(double value) => value < 0 ? 0 : (value > 255 ? 255 : value.round());

img.Image imageOfFrame(CapturedFrame frame) {
  final image = img.Image(width: frame.width, height: frame.height);
  final luma = frame.planes.first;
  final isSinglePlane = frame.planes.length == 1;
  final chromaStart = luma.bytesPerRow * frame.height;
  for (var y = 0; y < frame.height; y++) {
    for (var x = 0; x < frame.width; x++) {
      final brightness = luma.bytes[y * luma.bytesPerRow + x];
      int blueDifference;
      int redDifference;
      if (isSinglePlane) {
        final chroma = chromaStart + (y >> 1) * luma.bytesPerRow + (x & ~1);
        redDifference = chroma < luma.bytes.length ? luma.bytes[chroma] : 128;
        blueDifference = chroma + 1 < luma.bytes.length ? luma.bytes[chroma + 1] : 128;
      } else {
        final blue = frame.planes[1];
        final red = frame.planes[2];
        final blueIndex = (y >> 1) * blue.bytesPerRow + (x >> 1) * (blue.bytesPerPixel ?? 1);
        final redIndex = (y >> 1) * red.bytesPerRow + (x >> 1) * (red.bytesPerPixel ?? 1);
        blueDifference = blueIndex < blue.bytes.length ? blue.bytes[blueIndex] : 128;
        redDifference = redIndex < red.bytes.length ? red.bytes[redIndex] : 128;
      }
      final u = blueDifference - 128;
      final v = redDifference - 128;
      image.setPixelRgb(x, y, _clamp(brightness + 1.402 * v), _clamp(brightness - 0.344136 * u - 0.714136 * v), _clamp(brightness + 1.772 * u));
    }
  }
  return frame.rotationDegrees % 360 == 0 ? image : img.copyRotate(image, angle: frame.rotationDegrees);
}

Uint8List _encodeFrame(CapturedFrame frame, int? maximumSide) {
  var image = imageOfFrame(frame);
  if (maximumSide != null && (image.width > maximumSide || image.height > maximumSide)) {
    image = image.width >= image.height ? img.copyResize(image, width: maximumSide) : img.copyResize(image, height: maximumSide);
  }
  return Uint8List.fromList(img.encodeJpg(image, quality: 90));
}

Future<Uint8List> encodeFrameAsJpeg(CapturedFrame frame, {int? maximumSide}) => Isolate.run(() => _encodeFrame(frame, maximumSide));

class NextFrameRequest {
  Completer<CapturedFrame>? _pending;

  bool get isWaiting => _pending != null;

  Future<CapturedFrame> next({Duration timeout = const Duration(seconds: 3)}) {
    final pending = _pending ??= Completer<CapturedFrame>();
    return pending.future.timeout(timeout, onTimeout: () {
      _pending = null;
      throw TimeoutException('no camera frame');
    });
  }

  bool serve(CameraImage frame, {required int rotationDegrees}) {
    final pending = _pending;
    if (pending == null) {
      return false;
    }
    _pending = null;
    pending.complete(captureFrame(frame, rotationDegrees: rotationDegrees));
    return true;
  }
}

double sharpnessOf(CapturedFrame frame, {int step = 4}) {
  final luma = frame.planes.first;
  final bytes = luma.bytes;
  final stride = luma.bytesPerRow;
  final left = frame.width ~/ 10;
  final top = frame.height ~/ 10;
  final right = frame.width - left - 1;
  final bottom = frame.height - top - 1;
  var count = 0;
  var sumOfSquares = 0.0;
  for (var y = top + 1; y < bottom; y += step) {
    for (var x = left + 1; x < right; x += step) {
      final center = y * stride + x;
      if (center + stride >= bytes.length) {
        continue;
      }
      final laplacian = 4 * bytes[center] - bytes[center - 1] - bytes[center + 1] - bytes[center - stride] - bytes[center + stride];
      sumOfSquares += laplacian * laplacian;
      count++;
    }
  }
  return count == 0 ? 0 : sumOfSquares / count;
}

Future<CapturedFrame> sharpestFrame(NextFrameRequest request, {int count = 3}) async {
  CapturedFrame? sharpest;
  var bestSharpness = -1.0;
  for (var index = 0; index < count; index++) {
    final frame = await request.next();
    final sharpness = sharpnessOf(frame);
    if (sharpness > bestSharpness) {
      sharpest = frame;
      bestSharpness = sharpness;
    }
  }
  return sharpest!;
}
