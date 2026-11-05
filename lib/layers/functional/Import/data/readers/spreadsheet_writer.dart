import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';

Uint8List csvBytesOf(List<List<String>> rows) => Uint8List.fromList(utf8.encode('\uFEFF${Csv(fieldDelimiter: ';').encode(rows)}'));
