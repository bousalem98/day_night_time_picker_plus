import 'package:day_night_time_picker_plus/lib/constants.dart';
import 'package:day_night_time_picker_plus/lib/sky.dart';
import 'package:day_night_time_picker_plus/lib/state/state_container.dart';
import 'package:material_ui/material_ui.dart';

import './sun_moon.dart';

/// Height of the banner
const double _bannerHeight = 150;

/// [Widget] for rendering the sky, with the sun and the moon moving through it.
///
/// A single animated value, the time in minutes, drives the whole scene. That
/// keeps the colors and both bodies in sync, keeps the bodies on their arcs
/// while animating, and lets a new time interrupt the animation smoothly.
class DayNightBanner extends StatefulWidget {
  final TimeOfDay sunrise;
  final TimeOfDay sunset;
  final int duskSpanInMinutes;

  const DayNightBanner({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.duskSpanInMinutes,
  });

  @override
  State<DayNightBanner> createState() => _DayNightBannerState();
}

class _DayNightBannerState extends State<DayNightBanner> {
  /// The time being animated to. It is not wrapped to a single day, so that
  /// the animation can take the shortest way through midnight.
  double? _target;

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    if (!timeState.widget.displayHeader!) {
      return const SizedBox(height: 12);
    }

    final time = timeState.time;
    final minutes = time.hour * 60.0 + time.minute;
    final target = _target == null
        ? minutes
        : SkyModel.nearestEquivalent(_target!, minutes);
    _target = target;

    final sky = SkyModel(
      sunrise: widget.sunrise,
      sunset: widget.sunset,
      duskSpanInMinutes: widget.duskSpanInMinutes,
    );

    return ExcludeSemantics(
      child: RepaintBoundary(
        child: SizedBox(
          height: _bannerHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.biggest;
              return ClipRect(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: target, end: target),
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 450),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    final palette = sky.paletteAt(value);
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: SkyBackPainter(palette)),
                        ),
                        _body(
                          SkyModel.arcPosition(sky.moonProgress(value), size),
                          isSun: false,
                        ),
                        _body(
                          SkyModel.arcPosition(sky.sunProgress(value), size),
                          isSun: true,
                        ),
                        Positioned.fill(
                          child: CustomPaint(
                            painter: SkyFrontPainter(palette, value),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _body(Offset center, {required bool isSun}) {
    return Positioned(
      left: center.dx - SUN_MOON_WIDTH / 2,
      top: center.dy - SUN_MOON_WIDTH / 2,
      width: SUN_MOON_WIDTH,
      height: SUN_MOON_WIDTH,
      child: SunMoon(isSun: isSun),
    );
  }
}
