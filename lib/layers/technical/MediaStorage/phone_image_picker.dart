import 'dart:typed_data';

import 'package:akashic/layers/technical/MediaStorage/in_app_camera_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract interface class PhoneImagePicker {
  Future<Uint8List?> takePhoto();
  Future<Uint8List?> pickFromGallery();
}

class ImagePickerPhoneImagePicker implements PhoneImagePicker {
  ImagePickerPhoneImagePicker({ImagePicker? picker, this._navigator}) : _picker = picker ?? ImagePicker();

  static const double _maximumSide = 1200;

  final ImagePicker _picker;
  final NavigatorState? Function()? _navigator;

  @override
  Future<Uint8List?> takePhoto() async {
    final navigator = _navigator?.call();
    if (navigator == null) {
      return _pick(ImageSource.camera);
    }
    return navigator.push<Uint8List>(MaterialPageRoute(fullscreenDialog: true, builder: (_) => InAppCameraPage(maximumSide: _maximumSide.round())));
  }

  @override
  Future<Uint8List?> pickFromGallery() => _pick(ImageSource.gallery);

  Future<Uint8List?> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, maxWidth: _maximumSide, maxHeight: _maximumSide, imageQuality: 88);
    return picked?.readAsBytes();
  }
}
