import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitanexus_widgetbook/showcase/design_system_showcase.dart';

void main() {
  testWidgets('DesignSystemShowcase renderiza el ColorScheme M3',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: DesignSystemShowcase())),
    );
    expect(find.text('ColorScheme M3 (seed #1A5276)'), findsOneWidget);
  });
}
