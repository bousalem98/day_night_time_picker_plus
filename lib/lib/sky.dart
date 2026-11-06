import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:day_night_time_picker_plus/lib/constants.dart';
import 'package:material_ui/material_ui.dart';

const double _minutesPerDay = 24 * 60;

/// The colors of the sky scene at a single moment of the day.
@immutable
class SkyPalette {
  /// Color at the top of the sky gradient.
  final Color top;

  /// Color at the horizon.
  final Color bottom;

  /// Color of the hills in the distance.
  final Color farHill;

  /// Color of the hills up close.
  final Color nearHill;

  /// Visibility of the stars, from `0` to `1`.
  final double stars;

  /// Visibility of the clouds, from `0` to `1`.
  final double clouds;

  const SkyPalette({
    required this.top,
    required this.bottom,
    required this.farHill,
    required this.nearHill,
    required this.stars,
    required this.clouds,
  });

  static const night = SkyPalette(
    top: Color(0xFF0B1030),
    bottom: Color(0xFF2B2F63),
    farHill: Color(0xFF1A1E45),
    nearHill: Color(0xFF0F1230),
    stars: 1,
    clouds: 0,
  );

  static const dawn = SkyPalette(
    top: Color(0xFF5A6DB8),
    bottom: Color(0xFFFFC7A1),
    farHill: Color(0xFF75709F),
    nearHill: Color(0xFF4A4378),
    stars: 0.15,
    clouds: 0.35,
  );

  static const day = SkyPalette(
    top: Color(0xFF3F9BE8),
    bottom: Color(0xFFBDE5FB),
    farHill: Color(0xFF8ECBA3),
    nearHill: Color(0xFF5BAA7C),
    stars: 0,
    clouds: 0.9,
  );

  static const dusk = SkyPalette(
    top: Color(0xFF574A9E),
    bottom: Color(0xFFFF9264),
    farHill: Color(0xFF7D5086),
    nearHill: Color(0xFF4B2F66),
    stars: 0.1,
    clouds: 0.4,
  );

  /// Interpolate between two palettes.
  static SkyPalette lerp(SkyPalette a, SkyPalette b, double t) => SkyPalette(
    top: Color.lerp(a.top, b.top, t)!,
    bottom: Color.lerp(a.bottom, b.bottom, t)!,
    farHill: Color.lerp(a.farHill, b.farHill, t)!,
    nearHill: Color.lerp(a.nearHill, b.nearHill, t)!,
    stars: lerpDouble(a.stars, b.stars, t)!,
    clouds: lerpDouble(a.clouds, b.clouds, t)!,
  );
}

/// Maps a time of day, in minutes since midnight, to the state of the sky.
///
/// The value can be any number of minutes, including negative ones or values
/// past midnight, so it can be animated across midnight without jumping.
@immutable
class SkyModel {
  /// Minutes since midnight of the sunrise.
  final double sunrise;

  /// Length of the day in minutes.
  final double dayLength;

  /// How long before the sunset the sky starts turning into dusk.
  final double duskSpan;

  /// Creates the model. A [sunset] that is not after the [sunrise] is treated
  /// as belonging to the next day.
  factory SkyModel({
    required TimeOfDay sunrise,
    required TimeOfDay sunset,
    required int duskSpanInMinutes,
  }) {
    final rise = sunrise.hour * 60.0 + sunrise.minute;
    final set = sunset.hour * 60.0 + sunset.minute;
    return SkyModel._(
      rise,
      set > rise ? set - rise : set - rise + _minutesPerDay,
      math.max(0, duskSpanInMinutes).toDouble(),
    );
  }

  const SkyModel._(this.sunrise, this.dayLength, this.duskSpan);

  double get _nightLength => _minutesPerDay - dayLength;

  /// The sky colors at the given time.
  SkyPalette paletteAt(double minutes) {
    final twilight = math.min(45.0, _nightLength / 3);
    final morning = math.min(60.0, dayLength / 3);
    final sunset = sunrise + dayLength;
    final start = sunrise - twilight;

    final stops = <(double, SkyPalette)>[
      (start, SkyPalette.night),
      (sunrise, SkyPalette.dawn),
      (sunrise + morning, SkyPalette.day),
      (math.max(sunrise + morning, sunset - duskSpan), SkyPalette.day),
      (sunset, SkyPalette.dusk),
      (sunset + twilight, SkyPalette.night),
      (start + _minutesPerDay, SkyPalette.night),
    ];

    final t = start + (minutes - start) % _minutesPerDay;
    for (var i = 0; i < stops.length - 1; i++) {
      final (from, a) = stops[i];
      final (to, b) = stops[i + 1];
      if (t <= to) {
        final span = to - from;
        return span <= 0 ? b : SkyPalette.lerp(a, b, (t - from) / span);
      }
    }
    return SkyPalette.night;
  }

  /// Progress of the sun across the sky: `0` at sunrise, `1` at sunset, and
  /// outside of that range while it is below the horizon.
  double sunProgress(double minutes) =>
      _progress(minutes, sunrise + dayLength / 2, dayLength);

  /// Progress of the moon across the sky: `0` at sunset, `1` at sunrise, and
  /// outside of that range while it is below the horizon.
  double moonProgress(double minutes) => _progress(
    minutes,
    sunrise + dayLength / 2 + _minutesPerDay / 2,
    math.max(1, _nightLength),
  );

  double _progress(double minutes, double middle, double length) {
    final half = _minutesPerDay / 2;
    final offset = (minutes - middle + half) % _minutesPerDay - half;
    return 0.5 + offset / length;
  }

  /// The value equivalent to [target] that is the closest to [current], so
  /// that going from 23:00 to 00:00 moves forward through midnight rather than
  /// backward through the entire day.
  static double nearestEquivalent(double current, double target) {
    final half = _minutesPerDay / 2;
    return current + (target - current + half) % _minutesPerDay - half;
  }

  /// Center of a body with the given [progress] on its arc across the [size].
  ///
  /// Both ends of the arc are completely below the [size], rather than on the
  /// horizon. The sun and the moon hand over at the sunrise and the sunset, so
  /// this guarantees that the two of them are never visible at the same time.
  static Offset arcPosition(double progress, Size size) {
    final hidden = size.height + SUN_MOON_WIDTH / 2;
    final peak = size.height * 0.34;
    final height = progress > 0 && progress < 1
        ? math.max(0.0, math.sin(math.pi * progress))
        : 0.0;
    return Offset(
      size.width * (0.1 + 0.8 * progress),
      // The power makes the body clear the hills soon after its time starts.
      hidden - math.pow(height, 0.6) * (hidden - peak),
    );
  }
}

/// Paints the part of the scene behind the sun and the moon.
class SkyBackPainter extends CustomPainter {
  /// The colors to paint with
  final SkyPalette palette;

  const SkyBackPainter(this.palette);

  // Fractional position (dx, dy) and radius (z) and brightness (w) of the stars.
  static final List<(double, double, double, double)> _stars = () {
    final random = math.Random(7);
    return List.generate(
      34,
      (_) => (
        random.nextDouble(),
        random.nextDouble() * 0.72,
        0.5 + random.nextDouble() * 0.9,
        0.35 + random.nextDouble() * 0.65,
      ),
    );
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [palette.top, palette.bottom],
        ).createShader(rect),
    );

    if (palette.stars <= 0.01) {
      return;
    }
    final paint = Paint();
    for (final (x, y, radius, brightness) in _stars) {
      paint.color = Colors.white.withValues(alpha: brightness * palette.stars);
      canvas.drawCircle(Offset(x * size.width, y * size.height), radius, paint);
    }
  }

  @override
  bool shouldRepaint(SkyBackPainter oldDelegate) =>
      oldDelegate.palette != palette;
}

/// Paints the part of the scene in front of the sun and the moon.
class SkyFrontPainter extends CustomPainter {
  /// The colors to paint with
  final SkyPalette palette;

  /// The current time, which makes the clouds drift as the time changes
  final double minutes;

  const SkyFrontPainter(this.palette, this.minutes);

  @override
  void paint(Canvas canvas, Size size) {
    if (palette.clouds > 0.01) {
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.75 * palette.clouds);
      _cloud(canvas, size, paint, base: 0.15, y: 0.24, scale: 1, speed: 0.5);
      _cloud(canvas, size, paint, base: 0.68, y: 0.44, scale: 0.72, speed: 0.3);
    }

    final w = size.width;
    final h = size.height;
    canvas.drawPath(
      Path()
        ..moveTo(0, h - 22)
        ..cubicTo(w * 0.22, h - 46, w * 0.42, h - 12, w * 0.62, h - 26)
        ..cubicTo(w * 0.78, h - 38, w * 0.9, h - 30, w, h - 18)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close(),
      Paint()..color = palette.farHill,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, h - 8)
        ..cubicTo(w * 0.2, h - 12, w * 0.32, h - 26, w * 0.52, h - 14)
        ..cubicTo(w * 0.7, h - 3, w * 0.86, h - 22, w, h - 12)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close(),
      Paint()..color = palette.nearHill,
    );
  }

  void _cloud(
    Canvas canvas,
    Size size,
    Paint paint, {
    required double base,
    required double y,
    required double scale,
    required double speed,
  }) {
    const margin = 60.0;
    final travel = size.width + margin * 2;
    final x =
        (base * size.width + minutes / _minutesPerDay * travel * speed) %
            travel -
        margin;
    final center = Offset(x, size.height * y);

    // A single path, so the overlapping parts do not get painted twice.
    canvas.drawPath(
      Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: center,
              width: 58 * scale,
              height: 15 * scale,
            ),
            Radius.circular(8 * scale),
          ),
        )
        ..addOval(
          Rect.fromCircle(
            center: center + Offset(-9 * scale, -6 * scale),
            radius: 9 * scale,
          ),
        )
        ..addOval(
          Rect.fromCircle(
            center: center + Offset(7 * scale, -8 * scale),
            radius: 12 * scale,
          ),
        ),
      paint,
    );
  }

  @override
  bool shouldRepaint(SkyFrontPainter oldDelegate) =>
      oldDelegate.palette != palette || oldDelegate.minutes != minutes;
}
