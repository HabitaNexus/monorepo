import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habitanexus_mobile/main.dart';

void main() {
  testWidgets('App arranca y muestra la home', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HabitaNexusApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HabitaNexusApp), findsOneWidget);
    expect(find.text('HabitaNexus'), findsOneWidget);
  });
}
