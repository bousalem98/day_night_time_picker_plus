import 'package:day_night_time_picker_plus/day_night_time_picker_plus.dart';
import 'package:day_night_time_picker_plus/lib/ampm.dart';
import 'package:day_night_time_picker_plus/lib/common/action_buttons.dart';
import 'package:day_night_time_picker_plus/lib/common/display_value.dart';
import 'package:day_night_time_picker_plus/lib/common/picker_colors.dart';
import 'package:day_night_time_picker_plus/lib/common/wrapper_container.dart';
import 'package:day_night_time_picker_plus/lib/common/wrapper_dialog.dart';
import 'package:day_night_time_picker_plus/lib/daynight_banner.dart';
import 'package:day_night_time_picker_plus/lib/state/state_container.dart';
import 'package:day_night_time_picker_plus/lib/utils.dart';
import 'package:material_ui/material_ui.dart';

/// Private class. [StatefulWidget] that renders the content of the picker.
// ignore: must_be_immutable
class DayNightTimePickerAndroid extends StatefulWidget {
  const DayNightTimePickerAndroid({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.duskSpanInMinutes,
  });
  final TimeOfDay sunrise;
  final TimeOfDay sunset;
  final int duskSpanInMinutes;

  @override
  DayNightTimePickerAndroidState createState() =>
      DayNightTimePickerAndroidState();
}

/// Picker state class
class DayNightTimePickerAndroidState extends State<DayNightTimePickerAndroid> {
  late TimeModelBindingState timeState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timeState = TimeModelBinding.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final picker = timeState.widget;
    final selected = timeState.selected;

    // The range of the slider, for the value that is currently selected
    late double min;
    late double max;
    late int divisions;
    late double value;
    switch (selected) {
      case SelectedInput.HOUR:
        min = picker.minHour!;
        max = picker.maxHour!;
        divisions = (max - min).round();
        value = timeState.time.hour.toDouble();
      case SelectedInput.MINUTE:
        min = getMin(picker.minMinute, picker.minuteInterval);
        max = getMax(picker.maxMinute, picker.minuteInterval);
        divisions = getDivisions((max - min).round(), picker.minuteInterval);
        value = timeState.time.minute.toDouble();
      case SelectedInput.SECOND:
        min = getMin(picker.minSecond, picker.secondInterval);
        max = getMax(picker.maxSecond, picker.secondInterval);
        divisions = getDivisions((max - min).round(), picker.secondInterval);
        value = timeState.time.second.toDouble();
    }

    final color = PickerColors.of(context).accent;

    final hourValue = picker.is24HrFormat
        ? timeState.time.hour
        : timeState.time.hourOfPeriod;

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
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    textDirection: picker.ltrMode
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DisplayValue(
                        onTap: picker.disableHour!
                            ? null
                            : () => timeState.onSelectedInputChange(
                                SelectedInput.HOUR,
                              ),
                        value: hourValue.toString().padLeft(2, '0'),
                        isSelected: selected == SelectedInput.HOUR,
                      ),
                      const DisplaySeparator(),
                      DisplayValue(
                        onTap: picker.disableMinute!
                            ? null
                            : () => timeState.onSelectedInputChange(
                                SelectedInput.MINUTE,
                              ),
                        value: timeState.time.minute.toString().padLeft(2, '0'),
                        isSelected: selected == SelectedInput.MINUTE,
                      ),
                      if (picker.showSecondSelector) ...[
                        const DisplaySeparator(),
                        DisplayValue(
                          onTap: () => timeState.onSelectedInputChange(
                            SelectedInput.SECOND,
                          ),
                          value: timeState.time.second.toString().padLeft(
                            2,
                            '0',
                          ),
                          isSelected: selected == SelectedInput.SECOND,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    tickMarkShape: SliderTickMarkShape.noTickMark,
                  ),
                  child: Slider(
                    onChangeEnd: (_) => onChangedSlider(),
                    value: value.clamp(min, max),
                    onChanged: timeState.onTimeChange,
                    min: min,
                    max: max,
                    divisions: divisions > 0 ? divisions : null,
                    activeColor: color,
                    inactiveColor: color.withValues(alpha: 0.18),
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

  void onChangedSlider() {
    if (!timeState.widget.disableAutoFocusToNextInput) {
      if (timeState.selected == SelectedInput.HOUR) {
        if (!(timeState.widget.disableMinute ?? false)) {
          timeState.onSelectedInputChange(SelectedInput.MINUTE);
        } else if (timeState.widget.showSecondSelector) {
          timeState.onSelectedInputChange(SelectedInput.SECOND);
        }
      } else if (timeState.selected == SelectedInput.MINUTE &&
          timeState.widget.showSecondSelector) {
        timeState.onSelectedInputChange(SelectedInput.SECOND);
      }
    }
    if (timeState.widget.isOnValueChangeMode) {
      timeState.onOk();
    }
  }
}
