import 'dart:io';

import 'package:akashic/layers/technical/AppShell/app_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the version shown in the app follows the one released from pubspec.yaml', () {
    final released = RegExp(r'^version: *([0-9.]+)', multiLine: true).firstMatch(File('pubspec.yaml').readAsStringSync())!.group(1);
    expect(AppVersion.name, released);
    expect(AppVersion.label, released);
  });
}
