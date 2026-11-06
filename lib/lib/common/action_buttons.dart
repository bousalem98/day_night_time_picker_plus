import 'package:day_night_time_picker_plus/lib/common/picker_colors.dart';
import 'package:day_night_time_picker_plus/lib/state/state_container.dart';
import 'package:material_ui/material_ui.dart';

/// Render the [Ok] and [Cancel] buttons
class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    final picker = timeState.widget;
    if (picker.isOnValueChangeMode) {
      return const SizedBox(height: 8);
    }

    final colors = PickerColors.of(context);
    final cancelStyle =
        picker.cancelButtonStyle ??
        picker.buttonStyle ??
        TextButton.styleFrom(foregroundColor: colors.unselected);
    final okText = Text(picker.okText, style: picker.okStyle);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (picker.showCancelButton)
          TextButton(
            style: cancelStyle,
            onPressed: timeState.onCancel,
            child: Text(picker.cancelText, style: picker.cancelStyle),
          ),
        SizedBox(width: picker.buttonsSpacing ?? 8),
        // A custom style was written for the text button, so keep it on one.
        if (picker.buttonStyle != null)
          TextButton(
            onPressed: timeState.onOk,
            style: picker.buttonStyle,
            child: okText,
          )
        else
          FilledButton(
            onPressed: timeState.onOk,
            style: FilledButton.styleFrom(
              backgroundColor: colors.accent,
              foregroundColor: colors.onAccent,
            ),
            child: okText,
          ),
      ],
    );
  }
}
