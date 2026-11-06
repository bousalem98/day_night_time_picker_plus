import 'package:day_night_time_picker_plus/day_night_time_picker_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders DayNightTimePicker inline (Android style)',
      (WidgetTester tester) async {
    Time selectedTime = Time(hour: 10, minute: 30);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: showPicker(
            value: selectedTime,
            isInlinePicker: true,
            onChange: (newTime) {
              selectedTime = newTime;
            },
          ),
        ),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('renders DayNightTimePicker inline (iOS style)',
      (WidgetTester tester) async {
    Time selectedTime = Time(hour: 10, minute: 30, second: 15);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: showPicker(
            value: selectedTime,
            isInlinePicker: true,
            iosStylePicker: true,
            showSecondSelector: true,
            onChange: (newTime) {
              selectedTime = newTime;
            },
          ),
        ),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
