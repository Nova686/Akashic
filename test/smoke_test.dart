import 'dart:io';

import 'package:akashic/layers/technical/AppShell/akashic_app.dart';
import 'package:akashic/layers/technical/AppShell/dependency_scope.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots', (tester) async {
    final dependencies = AkashicDependencies(database: AkashicDatabase.forTesting(), imageRoot: Directory.systemTemp);
    await tester.pumpWidget(AkashicApp(dependencies: dependencies));
    expect(find.byType(MaterialApp), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(Duration.zero);
    await dependencies.database.close();
  });
}
