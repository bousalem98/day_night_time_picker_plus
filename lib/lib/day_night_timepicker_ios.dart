// ignore_for_file: library_private_types_in_public_api

import 'package:day_night_time_picker_plus/day_night_time_picker_plus.dart';
import 'package:day_night_time_picker_plus/lib/common/action_buttons.dart';
import 'package:day_night_time_picker_plus/lib/common/display_wheel.dart';
import 'package:day_night_time_picker_plus/lib/common/picker_colors.dart';
import 'package:day_night_time_picker_plus/lib/common/wrapper_container.dart';
import 'package:day_night_time_picker_plus/lib/common/wrapper_dialog.dart';
import 'package:day_night_time_picker_plus/lib/state/state_container.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_ui/material_ui.dart';

import 'ampm.dart';
import 'daynight_banner.dart';
import 'utils.dart';

/// Widest a wheel gets, so that a few wheels stay together on a wide picker.
const double _maxWheelWidth = 88;

/// Private class. [StatefulWidget] that renders the content of the picker.
// ignore: must_be_immutable
class DayNightTimePickerIos extends StatefulWidget {
  const DayNightTimePickerIos({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.duskSpanInMinutes,
  });
  final TimeOfDay sunrise;
  final TimeOfDay sunset;
  final int duskSpanInMinutes;

  @override
  _DayNightTimePickerIosState createState() => _DayNightTimePickerIosState();
}

/// Picker state class
class _DayNightTimePickerIosState extends State<DayNightTimePickerIos> {
  /// Instance of the time state
  late TimeModelBindingState timeState;

  /// Whether [init] was called
  bool _initialized = false;

  /// Number of wheels being moved by [_syncWheels] rather than by the user
  int _syncing = 0;

  /// Controller for `hour` list
  late final FixedExtentScrollController _hourController;

  /// Controller for `minute` list
  late final FixedExtentScrollController _minuteController;

  /// Controller for `second` list
  late final FixedExtentScrollController _secondController;

  /// List of hours to show
  late final List<int?> hours;

  /// List of minutes to show
  late final List<int?> minutes;

  /// List of seconds to show
  late final List<int?> seconds;

  /// initial setup
  void init() {
    final picker = timeState.widget;
    hours = generateHours(
      ((picker.maxHour! - picker.minHour!) + 1).round(),
      picker.minHour,
      picker.maxHour,
    );

    final minMinute = getMin(picker.minMinute, picker.minuteInterval);
    final maxMinute = getMax(picker.maxMinute, picker.minuteInterval);
    minutes = generateMinutesOrSeconds(
      getDivisions((maxMinute - minMinute).round(), picker.minuteInterval),
      picker.minuteInterval,
      minMinute,
      maxMinute,
    );

    final minSecond = getMin(picker.minSecond, picker.secondInterval);
    final maxSecond = getMax(picker.maxSecond, picker.secondInterval);
    seconds = generateMinutesOrSeconds(
      getDivisions((maxSecond - minSecond).round(), picker.secondInterval),
      picker.secondInterval,
      minSecond,
      maxSecond,
    );

    final time = timeState.time;
    _hourController = FixedExtentScrollController(
      initialItem: nearestIndex(hours, time.hour),
    );
    _minuteController = FixedExtentScrollController(
      initialItem: nearestIndex(minutes, time.minute),
    );
    _secondController = FixedExtentScrollController(
      initialItem: nearestIndex(seconds, time.second),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timeState = TimeModelBinding.of(context);
    if (!_initialized) {
      _initialized = true;
      init();
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) => _syncWheels());
    }
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  /// Move the wheels to the current time, when it was changed by something
  /// other than them, such as the AM/PM control or a new `value`.
  void _syncWheels() {
    if (!mounted) {
      return;
    }
    final time = timeState.time;
    _syncWheel(_hourController, nearestIndex(hours, time.hour));
    _syncWheel(_minuteController, nearestIndex(minutes, time.minute));
    _syncWheel(_secondController, nearestIndex(seconds, time.second));
  }

  void _syncWheel(FixedExtentScrollController controller, int index) {
    if (!controller.hasClients || controller.selectedItem == index) {
      return;
    }
    // Do not fight with the user, whose scrolling is what sets the time anyway.
    if (_syncing == 0 && controller.position.isScrollingNotifier.value) {
      return;
    }
    _syncing++;
    controller
        .animateToItem(
          index,
          duration: MediaQuery.disableAnimationsOf(context)
              ? const Duration(milliseconds: 1)
              : const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        )
        .whenComplete(() => _syncing--);
  }

  /// Run [callback], unless the wheels were moved by [_syncWheels].
  ///
  /// A scroll notification can arrive during layout, when the state can not be
  /// changed yet. In that case, wait for the end of the frame.
  void _onUserScroll(VoidCallback callback) {
    if (_syncing > 0) {
      return;
    }
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          callback();
        }
      });
    } else {
      callback();
    }
  }

  /// Handle the wheel of [input] coming to rest
  void _onScrollEnd(SelectedInput input) {
    _onUserScroll(() {
      final picker = timeState.widget;
      if (!picker.disableAutoFocusToNextInput) {
        if (input == SelectedInput.HOUR && !picker.disableMinute!) {
          timeState.onSelectedInputChange(SelectedInput.MINUTE);
        } else if (input != SelectedInput.SECOND && picker.showSecondSelector) {
          timeState.onSelectedInputChange(SelectedInput.SECOND);
        }
      }
      if (picker.isOnValueChangeMode) {
        timeState.onOk();
      }
    });
  }

  int getModifiedLabel(int value) {
    if (timeState.widget.is24HrFormat) {
      return value;
    }
    if (value == 0) {
      return 12;
    }
    return value > 12 ? value - 12 : value;
  }

  @override
  Widget build(BuildContext context) {
    final picker = timeState.widget;
    final colors = PickerColors.of(context);
    final textDirection = picker.ltrMode
        ? TextDirection.ltr
        : TextDirection.rtl;
    final labelStyle =
        picker.hmsStyle ??
        Theme.of(context).textTheme.labelSmall!
            .copyWith(color: colors.unselected);

    Widget column(Widget child) => Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWheelWidth),
        child: child,
      ),
    );

    Widget wheel({
      required SelectedInput input,
      required FixedExtentScrollController controller,
      required List<int?> items,
      required void Function(double value) onChange,
      bool disabled = false,
      int Function(int)? label,
    }) => column(
      DisplayWheel(
        controller: controller,
        items: items,
        isSelected: timeState.selected == input,
        disabled: disabled,
        getModifiedLabel: label,
        onChange: (index) {
          if (_syncing == 0) {
            onChange(items[index]! + 0.0);
          }
        },
        onScrollStart: () =>
            _onUserScroll(() => timeState.onSelectedInputChange(input)),
        onScrollEnd: () => _onScrollEnd(input),
      ),
    );

    Widget label(String text) => column(
      Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(text, style: labelStyle, maxLines: 1),
        ),
      ),
    );

    return WrapperDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DayNightBanner(
            sunrise: widget.sunrise,
            sunset: widget.sunset,
            duskSpanInMinutes: widget.duskSpanInMinutes,
          ),
          WrapperContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const AmPm(),
                const SizedBox(height: 8),
                const Spacer(),
                Row(
                  textDirection: textDirection,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    label(picker.hourLabel!),
                    label(picker.minuteLabel!),
                    if (picker.showSecondSelector) label(picker.secondLabel!),
                  ],
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: picker.wheelHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // The band that marks the selected row across the wheels
                      Container(
                        height: wheelItemExtent,
                        decoration: BoxDecoration(
                          color: colors.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Row(
                        textDirection: textDirection,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          wheel(
                            input: SelectedInput.HOUR,
                            controller: _hourController,
                            items: hours,
                            onChange: timeState.onHourChange,
                            disabled: picker.disableHour!,
                            label: getModifiedLabel,
                          ),
                          wheel(
                            input: SelectedInput.MINUTE,
                            controller: _minuteController,
                            items: minutes,
                            onChange: timeState.onMinuteChange,
                            disabled: picker.disableMinute!,
                          ),
                          if (picker.showSecondSelector)
                            wheel(
                              input: SelectedInput.SECOND,
                              controller: _secondController,
                              items: seconds,
                              onChange: timeState.onSecondChange,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (!picker.hideButtons) const ActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
