import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_customer_app/main.dart';

void main() {
  testWidgets('App boots to the login screen when no session is cached', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FitnessCustomerApp()));
    // Avoid pumpAndSettle: the login screen may still have pending biometric/
    // secure-storage lookups whose indeterminate spinners never "settle" in
    // the test harness (no platform channel mocks registered).
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Καλωσήρθατε'), findsOneWidget);
  });
}
