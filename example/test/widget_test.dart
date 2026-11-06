import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Renders Day Night Time Picker Plus Demo smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Day Night Time Picker Plus'), findsOneWidget);
    expect(find.text('Open Time Picker'), findsOneWidget);
    expect(find.text('Inline Picker Style'), findsOneWidget);
  });
}
