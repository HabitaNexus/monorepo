import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitanexus_ui/habitanexus_ui.dart';

// ---------------------------------------------------------------------------
// Setup — fixtures puras + pump del organismo
// ---------------------------------------------------------------------------

const _spaces = [
  NearbySpace(
    id: '1',
    name: 'WeWork Escazú',
    type: SpaceType.coworking,
    distanceKm: 0.5,
    hasWifi: true,
  ),
  NearbySpace(
    id: '2',
    name: 'Café Avellaneda',
    type: SpaceType.cafe,
    distanceKm: 0.3,
    hasWifi: true,
  ),
];

Future<void> pumpOrganism(
  WidgetTester tester,
  NearbyCoworkings organism,
) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: organism)),
  );
}

// ---------------------------------------------------------------------------
// Casos — estados del organismo (QT4L: UI-02..UI-05)
// ---------------------------------------------------------------------------

void main() {
  testWidgets('renders names and distances', (tester) async {
    await pumpOrganism(
      tester,
      const NearbyCoworkings(spaces: _spaces),
    );
    expect(find.text('WeWork Escazú'), findsOneWidget);
    expect(find.text('Café Avellaneda'), findsOneWidget);
    expect(find.text('0.50 km'), findsOneWidget);
    expect(find.text('0.30 km'), findsOneWidget);
    expect(find.text('Ver buscador completo'), findsOneWidget);
  });

  testWidgets('shows progress when loading', (tester) async {
    await pumpOrganism(
      tester,
      const NearbyCoworkings(isLoading: true),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('WeWork Escazú'), findsNothing);
  });

  testWidgets('shows error message', (tester) async {
    await pumpOrganism(
      tester,
      const NearbyCoworkings(error: 'Sin conexión'),
    );
    expect(find.text('Sin conexión'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows empty message', (tester) async {
    await pumpOrganism(tester, const NearbyCoworkings());
    expect(
      find.text('No se encontraron espacios de trabajo cercanos'),
      findsOneWidget,
    );
  });

  testWidgets('tapping action invokes callback', (tester) async {
    var tapped = false;
    await pumpOrganism(
      tester,
      NearbyCoworkings(
        spaces: _spaces,
        onViewFullSearch: () => tapped = true,
      ),
    );
    await tester.tap(find.text('Ver buscador completo'));
    expect(tapped, isTrue);
  });
}
