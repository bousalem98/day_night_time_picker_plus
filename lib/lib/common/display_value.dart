import 'package:day_night_time_picker_plus/lib/common/picker_colors.dart';
import 'package:material_ui/material_ui.dart';

const _duration = Duration(milliseconds: 180);

/// Render the [Hour] or [Minute] value for `Android` picker
class DisplayValue extends StatelessWidget {
  /// The [value] to display
  final String value;

  /// The [onTap] handler
  final VoidCallback? onTap;

  /// Whether the [value] is selected or not
  final bool isSelected;

  /// Constructor for the [Widget]
  const DisplayValue({
    super.key,
    required this.value,
    this.onTap,
    this.isSelected = false,
  });

  /// Text style shared with the separator. The figures have the same width, so
  /// that the layout does not shift while the value changes.
  static TextStyle _style(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium!.copyWith(
        fontSize: 48,
        height: 1.15,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  @override
  Widget build(BuildContext context) {
    final colors = PickerColors.of(context);
    final radius = BorderRadius.circular(16);

    return Semantics(
      selected: isSelected,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: AnimatedContainer(
            duration: _duration,
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.accent.withValues(alpha: 0.14)
                  : colors.accent.withValues(alpha: 0),
              borderRadius: radius,
            ),
            child: AnimatedDefaultTextStyle(
              duration: _duration,
              curve: Curves.easeOut,
              style: _style(
                context,
              ).copyWith(color: isSelected ? colors.accent : colors.unselected),
              child: Text(value, textScaler: TextScaler.noScaling),
            ),
          ),
        ),
      ),
    );
  }
}

/// Render the `:` between the values for `Android` picker
class DisplaySeparator extends StatelessWidget {
  /// Constructor for the [Widget]
  const DisplaySeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Text(
        ':',
        textScaler: TextScaler.noScaling,
        style: DisplayValue._style(context).copyWith(
          color: PickerColors.of(context).unselected.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
