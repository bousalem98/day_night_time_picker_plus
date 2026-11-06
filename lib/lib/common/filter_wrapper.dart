import 'dart:ui';

import 'package:material_ui/material_ui.dart';

/// Blurs whatever is behind the picker, following the [animation] of the route.
///
/// It is a sibling of the picker rather than its parent, since a backdrop
/// filter inside of the picker's fade would not blend with it. The blur is not
/// applied when its `sigma` is `zero`, since `ImageFilter.blur` was causing an
/// issue in [web] in that case.
///
/// See https://github.com/flutter/flutter/issues/77258#issuecomment-822006335
class FilterWrapper extends StatelessWidget {
  /// The animation of the route, from `0` to `1`
  final Animation<double> animation;

  /// Blur amount when the picker is fully open
  final double sigma;

  /// Constructor for the [Widget]
  const FilterWrapper({super.key, required this.animation, this.sigma = 5});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final blur = sigma * animation.value;
          if (blur <= 0) {
            return const SizedBox.expand();
          }
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}
