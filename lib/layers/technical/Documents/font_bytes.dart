import 'package:flutter/services.dart';

Future<(Uint8List, Uint8List)> documentFonts() async => (
      (await rootBundle.load('assets/fonts/Lato-Regular.ttf')).buffer.asUint8List(),
      (await rootBundle.load('assets/fonts/Lato-Bold.ttf')).buffer.asUint8List(),
    );
