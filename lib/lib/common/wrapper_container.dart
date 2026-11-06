import 'package:day_night_time_picker_plus/lib/common/picker_colors.dart';
import 'package:day_night_time_picker_plus/lib/state/state_container.dart';
import 'package:material_ui/material_ui.dart';

/// Just a simple [Container] with common styling
class WrapperContainer extends StatelessWidget {
  /// The child [Widget] to render
  final Widget child;

  /// Constructor for the [Widget]
  const WrapperContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final picker = TimeModelBinding.of(context).widget;
    return Expanded(
      child: Container(
        // A minimum, so that taller content such as a tall wheel can not overflow.
        constraints: BoxConstraints(minHeight: picker.height),
        color: PickerColors.of(context).background,
        padding: picker.contentPadding,
        child: child,
      ),
    );
  }
}
