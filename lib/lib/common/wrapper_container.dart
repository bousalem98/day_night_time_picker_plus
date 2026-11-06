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
    var timeState = TimeModelBinding.of(context);
    double height = timeState.widget.height;
    Color backgroundColor = timeState.widget.backgroundColor;
    return Expanded(
      child: Container(
        height: height,
        color: backgroundColor,
        padding: timeState.widget.contentPadding,
        child: child,
      ),
    );
  }
}
