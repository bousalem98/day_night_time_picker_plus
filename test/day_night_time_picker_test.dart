import 'package:day_night_time_picker_plus/day_night_time_picker_plus.dart';
import 'package:day_night_time_picker_plus/lib/sky.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Widget inline(Widget picker, {ThemeData? theme}) => MaterialApp(
    theme: theme,
    home: Scaffold(body: picker),
  );

  Future<void> openPopup(
    WidgetTester tester, {
    required Time value,
    void Function(Time)? onChange,
    void Function()? onCancel,
    bool blurredBackground = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                showPicker(
                  value: value,
                  onChange: onChange ?? (_) {},
                  onCancel: onCancel,
                  blurredBackground: blurredBackground,
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('rendering', () {
    testWidgets('renders inline (Android style)', (tester) async {
      await tester.pumpWidget(
        inline(
          showPicker(
            value: Time(hour: 10, minute: 30),
            isInlinePicker: true,
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('10'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('renders inline with seconds on a phone (iOS style)', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(360, 720));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        inline(
          showPicker(
            value: Time(hour: 10, minute: 30, second: 15),
            isInlinePicker: true,
            iosStylePicker: true,
            showSecondSelector: true,
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });

    for (final iosStyle in [false, true]) {
      testWidgets('uses the provided width (iOS style: $iosStyle)', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          inline(
            showPicker(
              value: Time(hour: 10, minute: 30),
              isInlinePicker: true,
              iosStylePicker: iosStyle,
              width: 320,
              onChange: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();

        final dialog = find.descendant(
          of: find.byType(Dialog),
          matching: find.byType(Material),
        );
        expect(tester.getSize(dialog.first).width, 320);
      });
    }

    testWidgets('a tall wheel makes the picker grow instead of overflow', (
      tester,
    ) async {
      await tester.pumpWidget(
        inline(
          showPicker(
            value: Time(hour: 10, minute: 30),
            isInlinePicker: true,
            iosStylePicker: true,
            wheelHeight: 240,
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('follows a dark theme by default', (tester) async {
      final theme = ThemeData(brightness: Brightness.dark);
      await tester.pumpWidget(
        inline(
          showPicker(
            value: Time(hour: 10, minute: 30),
            isInlinePicker: true,
            onChange: (_) {},
          ),
          theme: theme,
        ),
      );
      await tester.pumpAndSettle();

      final dialog = tester.widget<Dialog>(find.byType(Dialog));
      expect(dialog.backgroundColor, theme.colorScheme.surface);
    });
  });

  group('popup', () {
    testWidgets('tapping beside the picker dismisses it', (tester) async {
      await openPopup(tester, value: Time(hour: 10, minute: 30));
      expect(find.byType(Dialog), findsOneWidget);

      final center = tester.getCenter(find.byType(Dialog));
      await tester.tapAt(Offset(2, center.dy));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('tapping on the picker does not dismiss it', (tester) async {
      await openPopup(tester, value: Time(hour: 10, minute: 30));

      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('keeps its state while closing with a blur', (tester) async {
      Time? result;
      await openPopup(
        tester,
        value: Time(hour: 10, minute: 30),
        onChange: (time) => result = time,
        blurredBackground: true,
      );

      await tester.tap(find.text('pm'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ok'));
      await tester.pump(const Duration(milliseconds: 90));
      expect(find.text('10'), findsOneWidget);
      await tester.pumpAndSettle();

      expect(result?.hour, 22);
      expect(find.byType(Dialog), findsNothing);
    });
  });

  group('custom onCancel', () {
    testWidgets('Ok closes the popup without calling it', (tester) async {
      var cancelled = 0;
      Time? result;
      await openPopup(
        tester,
        value: Time(hour: 10, minute: 30),
        onChange: (time) => result = time,
        onCancel: () => cancelled++,
      );

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(result?.hour, 10);
      expect(cancelled, 0);
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('Cancel calls it and leaves the closing to it', (tester) async {
      var cancelled = 0;
      Time? result;
      await openPopup(
        tester,
        value: Time(hour: 10, minute: 30),
        onChange: (time) => result = time,
        onCancel: () => cancelled++,
      );

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(cancelled, 1);
      expect(result, isNull);
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('Ok on an inline picker does not call it', (tester) async {
      var cancelled = 0;
      await tester.pumpWidget(
        inline(
          showPicker(
            value: Time(hour: 10, minute: 30),
            isInlinePicker: true,
            onChange: (_) {},
            onCancel: () => cancelled++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(cancelled, 0);
    });

    testWidgets('without it, Cancel closes without a change', (tester) async {
      Time? result;
      await openPopup(
        tester,
        value: Time(hour: 10, minute: 30),
        onChange: (time) => result = time,
      );

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isNull);
      expect(find.byType(Dialog), findsNothing);
    });
  });

  group('state', () {
    testWidgets('an inline picker follows a new value', (tester) async {
      Widget build(Time value) => inline(
        showPicker(value: value, isInlinePicker: true, onChange: (_) {}),
      );

      await tester.pumpWidget(build(Time(hour: 10, minute: 30)));
      await tester.pumpAndSettle();
      await tester.pumpWidget(build(Time(hour: 9, minute: 45)));
      await tester.pumpAndSettle();

      expect(find.text('09'), findsOneWidget);
      expect(find.text('45'), findsOneWidget);
    });

    testWidgets('the second slider uses the second interval', (tester) async {
      await tester.pumpWidget(
        inline(
          showPicker(
            value: Time(hour: 10, minute: 30, second: 20),
            isInlinePicker: true,
            showSecondSelector: true,
            minuteInterval: TimePickerInterval.FIVE,
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('20'));
      await tester.pumpAndSettle();

      expect(tester.widget<Slider>(find.byType(Slider)).divisions, 59);
    });
  });

  group('wheels', () {
    FixedExtentScrollController controller(WidgetTester tester, int index) =>
        tester
                .widgetList<ListWheelScrollView>(
                  find.byType(ListWheelScrollView),
                )
                .elementAt(index)
                .controller!
            as FixedExtentScrollController;

    testWidgets('the AM/PM control moves the hour wheel', (tester) async {
      Time? result;
      await tester.pumpWidget(
        inline(
          showPicker(
            value: Time(hour: 10, minute: 30),
            isInlinePicker: true,
            iosStylePicker: true,
            onChange: (time) => result = time,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(controller(tester, 0).selectedItem, 10);

      await tester.tap(find.text('pm'));
      await tester.pumpAndSettle();
      expect(controller(tester, 0).selectedItem, 22);

      // The time must not be changed by the wheel on its way there.
      await tester.tap(find.text('Ok'));
      expect(result?.hour, 22);
    });

    testWidgets('scrolling a wheel changes the time', (tester) async {
      Time? result;
      await tester.pumpWidget(
        inline(
          showPicker(
            value: Time(hour: 10, minute: 30),
            isInlinePicker: true,
            iosStylePicker: true,
            onChange: (time) => result = time,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, -80),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      expect(result?.hour, controller(tester, 0).selectedItem);
      expect(result?.hour, isNot(10));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a value between the steps starts on the nearest one', (
      tester,
    ) async {
      await tester.pumpWidget(
        inline(
          showPicker(
            value: Time(hour: 10, minute: 33),
            isInlinePicker: true,
            iosStylePicker: true,
            minuteInterval: TimePickerInterval.FIVE,
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(controller(tester, 1).selectedItem, 7);
    });

    testWidgets('can be disposed in the middle of a scroll', (tester) async {
      await tester.pumpWidget(
        inline(
          showPicker(
            value: Time(hour: 10, minute: 30),
            isInlinePicker: true,
            iosStylePicker: true,
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.fling(
        find.byType(ListWheelScrollView).first,
        const Offset(0, -200),
        1000,
      );
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('SkyModel', () {
    final sky = SkyModel(
      sunrise: const TimeOfDay(hour: 6, minute: 0),
      sunset: const TimeOfDay(hour: 18, minute: 0),
      duskSpanInMinutes: 120,
    );

    test('has the expected colors through the day', () {
      expect(sky.paletteAt(0).top, SkyPalette.night.top);
      expect(sky.paletteAt(6 * 60).top, SkyPalette.dawn.top);
      expect(sky.paletteAt(12 * 60).top, SkyPalette.day.top);
      expect(sky.paletteAt(18 * 60).top, SkyPalette.dusk.top);
    });

    testWidgets('accepts a dusk span that is not in whole hours', (
      tester,
    ) async {
      // This used to fail on building a TimeOfDay with a negative minute.
      await tester.pumpWidget(
        inline(
          showPicker(
            value: Time(hour: 17, minute: 0),
            isInlinePicker: true,
            duskSpanInMinutes: 90,
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    test('accepts a sunset after midnight', () {
      final model = SkyModel(
        sunrise: const TimeOfDay(hour: 20, minute: 0),
        sunset: const TimeOfDay(hour: 4, minute: 0),
        duskSpanInMinutes: 60,
      );
      expect(model.sunProgress(0), 0.5);
    });

    test('the bodies are above the horizon during their time only', () {
      expect(sky.sunProgress(12 * 60), 0.5);
      expect(sky.sunProgress(6 * 60), 0);
      expect(sky.sunProgress(18 * 60), 1);
      expect(sky.sunProgress(0), anyOf(lessThan(0), greaterThan(1)));

      expect(sky.moonProgress(0), 0.5);
      expect(sky.moonProgress(18 * 60), 0);
      expect(sky.moonProgress(6 * 60), 1);
      expect(sky.moonProgress(12 * 60), anyOf(lessThan(0), greaterThan(1)));
    });

    test('has no jump while the time crosses midnight', () {
      for (var minutes = 23 * 60.0; minutes < 25 * 60; minutes += 5) {
        expect(
          (sky.moonProgress(minutes + 5) - sky.moonProgress(minutes)).abs(),
          lessThan(0.01),
        );
      }
    });

    test('never shows the sun and the moon at the same time', () {
      const size = Size(300, 150);
      bool visible(double progress) {
        final center = SkyModel.arcPosition(progress, size);
        return center.dy - SUN_MOON_WIDTH / 2 < size.height;
      }

      final models = [
        sky,
        SkyModel(
          sunrise: const TimeOfDay(hour: 5, minute: 30),
          sunset: const TimeOfDay(hour: 20, minute: 15),
          duskSpanInMinutes: 45,
        ),
        SkyModel(
          sunrise: const TimeOfDay(hour: 20, minute: 0),
          sunset: const TimeOfDay(hour: 4, minute: 0),
          duskSpanInMinutes: 60,
        ),
      ];
      for (final model in models) {
        for (var minutes = 0.0; minutes < 24 * 60; minutes += 0.5) {
          expect(
            visible(model.sunProgress(minutes)) &&
                visible(model.moonProgress(minutes)),
            isFalse,
            reason: 'both are visible at minute $minutes',
          );
        }
      }

      expect(visible(sky.sunProgress(12 * 60)), isTrue);
      expect(visible(sky.moonProgress(12 * 60)), isFalse);
      expect(visible(sky.moonProgress(0)), isTrue);
      expect(visible(sky.sunProgress(0)), isFalse);
    });

    test('the bodies are clear of the hills soon after they rise', () {
      const size = Size(300, 150);
      // Half an hour after the sunrise, the top of the sun is above the hills.
      final center = SkyModel.arcPosition(sky.sunProgress(6.5 * 60), size);
      expect(center.dy - SUN_MOON_WIDTH / 2, lessThan(size.height - 40));
    });

    test('goes the short way around midnight', () {
      expect(SkyModel.nearestEquivalent(23 * 60, 0), 24 * 60);
      expect(SkyModel.nearestEquivalent(0, 23 * 60), -60);
      expect(SkyModel.nearestEquivalent(24 * 60, 30), 24 * 60 + 30);
    });
  });
}
