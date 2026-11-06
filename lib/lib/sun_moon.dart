import 'package:day_night_time_picker_plus/lib/state/state_container.dart';
import 'package:material_ui/material_ui.dart';

/// [Widget] for rendering the Sun or the Moon Asset
class SunMoon extends StatelessWidget {
  /// Whether to display the Sun rather than the Moon
  final bool isSun;

  /// Initialize the Class
  const SunMoon({super.key, required this.isSun});

  @override
  Widget build(BuildContext context) {
    final picker = TimeModelBinding.of(context).widget;
    final custom = isSun ? picker.sunAsset : picker.moonAsset;
    if (custom != null) {
      return custom;
    }

    return Image(
      image: AssetImage(
        'packages/day_night_time_picker_plus/assets/${isSun ? 'sun' : 'moon'}.png',
      ),
      // Fade in rather than pop in when the picker opens before it is decoded.
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: child,
        );
      },
    );
  }
}
