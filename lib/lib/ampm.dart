import 'package:day_night_time_picker_plus/lib/common/picker_colors.dart';
import 'package:day_night_time_picker_plus/lib/state/state_container.dart';
import 'package:material_ui/material_ui.dart';

const _duration = Duration(milliseconds: 220);

/// [Widget] for rendering the AM/PM control, a pill with a sliding thumb
class AmPm extends StatelessWidget {
  const AmPm({super.key});

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    if (timeState.widget.is24HrFormat) {
      return const SizedBox.shrink();
    }

    final colors = PickerColors.of(context);
    final isAm = timeState.time.period == DayPeriod.am;
    final radius = BorderRadius.circular(18);

    Widget option(String label, DayPeriod period) {
      final selected = timeState.time.period == period;
      final enabled = !selected && timeState.checkIfWithinRange(period);
      return Expanded(
        child: Semantics(
          selected: selected,
          child: InkWell(
            borderRadius: radius,
            onTap: enabled ? () => timeState.onAmPmChange(period) : null,
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: _duration,
                curve: Curves.easeOut,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? colors.onAccent
                      : colors.unselected.withValues(alpha: enabled ? 1 : 0.38),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(label, maxLines: 1),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Center(
      child: SizedBox(
        width: 124,
        height: 36,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.accent.withValues(alpha: 0.1),
            borderRadius: radius,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedAlign(
                  duration: _duration,
                  curve: Curves.easeOutCubic,
                  alignment: isAm
                      ? AlignmentDirectional.centerStart
                      : AlignmentDirectional.centerEnd,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.accent,
                          borderRadius: radius,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: Row(
                    children: [
                      option(timeState.widget.amLabel, DayPeriod.am),
                      option(timeState.widget.pmLabel, DayPeriod.pm),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
