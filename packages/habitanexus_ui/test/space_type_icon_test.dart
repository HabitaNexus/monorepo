import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitanexus_ui/habitanexus_ui.dart';

// ---------------------------------------------------------------------------
// Setup — pump del átomo bajo MaterialApp (tema por defecto)
// ---------------------------------------------------------------------------

Future<void> pumpIcon(WidgetTester tester, SpaceType type,
    {double size = 40}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SpaceTypeIcon(type: type, size: size)),
    ),
  );
}

// ---------------------------------------------------------------------------
// Casos — un icono visible por categoría (QT4L: UI-01)
// ---------------------------------------------------------------------------

void main() {
  testWidgets('renders icon per SpaceType', (tester) async {
    await pumpIcon(tester, SpaceType.coworking);
    expect(find.byIcon(Icons.work_outline), findsOneWidget);

    await pumpIcon(tester, SpaceType.cafe);
    expect(find.byIcon(Icons.local_cafe_outlined), findsOneWidget);

    await pumpIcon(tester, SpaceType.other);
    expect(find.byIcon(Icons.place_outlined), findsOneWidget);
  });

  testWidgets('respects requested size', (tester) async {
    await pumpIcon(tester, SpaceType.cafe, size: 64);
    expect(
      tester.getSize(find.byType(Container).first),
      const Size(64, 64),
    );
  });
}
