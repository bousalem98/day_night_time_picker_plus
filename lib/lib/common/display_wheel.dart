import 'package:day_night_time_picker_plus/lib/common/picker_colors.dart';
import 'package:day_night_time_picker_plus/lib/state/state_container.dart';
import 'package:material_ui/material_ui.dart';

/// Height of a single item of the wheel
const double wheelItemExtent = 40;

/// Render the [Hour] or [Minute] wheel for `IOS` picker
class DisplayWheel extends StatelessWidget {
  /// [Controller] for the wheel
  final FixedExtentScrollController controller;

  /// The items rendered for the wheel
  final List<int?> items;

  /// The Change handler
  final void Function(int value) onChange;

  /// Called when the wheel starts moving
  final VoidCallback? onScrollStart;

  /// Called when the wheel has come to rest
  final VoidCallback? onScrollEnd;

  /// Callback to render custom label
  final int Function(int item)? getModifiedLabel;

  /// Whether the wheel is selected or not
  final bool isSelected;

  /// Whether the wheel is disabled or not
  final bool disabled;

  /// Constructor for the [Widget]
  const DisplayWheel({
    super.key,
    required this.controller,
    required this.items,
    required this.onChange,
    this.onScrollStart,
    this.onScrollEnd,
    this.isSelected = false,
    this.disabled = false,
    this.getModifiedLabel,
  });

  @override
  Widget build(BuildContext context) {
    final magnification = TimeModelBinding.of(context)
        .widget
        .wheelMagnification;
    final colors = PickerColors.of(context);
    final style = Theme.of(context).textTheme.headlineSmall!.copyWith(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      fontFeatures: const [FontFeature.tabularFigures()],
      color: isSelected ? colors.accent : colors.unselected,
    );

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          onScrollStart?.call();
        } else if (notification is ScrollEndNotification) {
          onScrollEnd?.call();
        }
        return false;
      },
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: wheelItemExtent,
        physics: disabled
            ? const NeverScrollableScrollPhysics()
            : const FixedExtentScrollPhysics(parent: BouncingScrollPhysics()),
        overAndUnderCenterOpacity: disabled ? 0 : 0.4,
        perspective: 0.004,
        useMagnifier: magnification != 1,
        magnification: magnification,
        onSelectedItemChanged: onChange,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (context, index) {
            final val =
                (getModifiedLabel?.call(items[index]!) ?? (items[index]!))
                    .toString()
                    .padLeft(2, '0');
            return Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                style: style,
                child: Text(val, textScaler: TextScaler.noScaling),
              ),
            );
          },
        ),
      ),
    );
  }
}
