import 'package:day_night_time_picker_plus/lib/state/state_container.dart';
import 'package:material_ui/material_ui.dart';

/// The colors of the picker: what the user provided, or else what the theme
/// says, so the picker follows light and dark themes on its own.
@immutable
class PickerColors {
  /// Color of the selected values and of the main actions
  final Color accent;

  /// Color of the content displayed on top of the [accent]
  final Color onAccent;

  /// Color of the values that are not selected
  final Color unselected;

  /// Color of the picker's surface
  final Color background;

  const PickerColors._({
    required this.accent,
    required this.onAccent,
    required this.unselected,
    required this.background,
  });

  /// Resolve the colors for the given [context]
  factory PickerColors.of(BuildContext context) {
    final picker = TimeModelBinding.of(context).widget;
    final scheme = Theme.of(context).colorScheme;
    final accent = picker.accentColor ?? scheme.primary;

    return PickerColors._(
      accent: accent,
      onAccent: accent == scheme.primary
          ? scheme.onPrimary
          : ThemeData.estimateBrightnessForColor(accent) == Brightness.dark
          ? Colors.white
          : Colors.black,
      unselected: picker.unselectedColor ?? scheme.onSurfaceVariant,
      background: picker.backgroundColor ?? scheme.surface,
    );
  }
}
