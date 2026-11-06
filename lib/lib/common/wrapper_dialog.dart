import 'dart:math' as math;

import 'package:day_night_time_picker_plus/lib/common/picker_colors.dart';
import 'package:day_night_time_picker_plus/lib/constants.dart';
import 'package:day_night_time_picker_plus/lib/state/state_container.dart';
import 'package:material_ui/material_ui.dart';

/// Just a simple [Dialog] with common styling
class WrapperDialog extends StatelessWidget {
  /// The child [Widget] to render
  final Widget child;

  /// Constructor for the [Widget]
  const WrapperDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final picker = TimeModelBinding.of(context).widget;
    final borderRadius = picker.borderRadius ?? BORDER_RADIUS;

    // The scroll view is inside of the dialog and not around it, so that it can
    // only take taps on the picker and those around it reach the barrier. It
    // only scrolls when the picker does not fit, like in landscape.
    return Dialog(
      insetPadding: picker.dialogInsetPadding,
      backgroundColor: PickerColors.of(context).background,
      surfaceTintColor: Colors.transparent,
      constraints: BoxConstraints(
        minWidth: math.min(280, picker.width),
        maxWidth: picker.width,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: picker.elevation ?? ELEVATION,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SingleChildScrollView(child: IntrinsicHeight(child: child)),
      ),
    );
  }
}
