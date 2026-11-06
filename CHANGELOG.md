## [0.0.2] - 6th November 2026.

### Design

- New sky banner: a gradient that changes continuously through dawn, day, dusk and night, with stars, clouds and hills.
- The sun and the moon now rise and set on arcs between `sunrise` and `sunset`, and move with the minutes as well as the hours.
- New AM/PM control with a sliding thumb, tinted pills for the selected hour/minute/second, and a selection band across the wheels.
- `Ok` is now a filled button in the accent color, unless a `buttonStyle` is provided.
- Follows light and dark themes: `backgroundColor` now defaults to the theme's surface instead of white, `accentColor` to its primary color, and `unselectedColor` to its `onSurfaceVariant`.
- `borderRadius` now defaults to `24`, `wheelHeight` to `120`, and `buttonsSpacing` to `8`.

### Animations

- The sun and the moon follow their arcs while animating, instead of cutting across in a straight line, and go through midnight the short way.
- The sky color, the sun and the moon now share one animation, instead of running on durations of 1s and 200ms.
- The popup no longer rebuilds the whole picker on every frame of its transition.
- The background blur fades in and out with the popup, instead of appearing all at once.
- The iOS style wheels now follow the AM/PM control. Before, the wheel kept the old value and scrolling it switched the period back.
- The iOS style wheels no longer add a new listener on each scroll tick, and their controllers are now disposed.
- The sun and the moon fade in when opening the picker, instead of popping in.
- Animations respect the platform's reduced motion setting.

### Fixes

- `width` is now applied. Before, it was ignored and the picker took all of the available width. It also no longer gets replaced by `350` for `iosStylePicker`, which is now just its default.
- A `duskSpanInMinutes` that is not in whole hours no longer throws.
- Tapping to the left or right of the popup now dismisses it.
- `wheelMagnification` now has an effect.
- The second slider now uses `secondInterval` and the second range, instead of those for minutes.
- A value that is not on a step of `minuteInterval` no longer breaks the initial position of the wheel.
- An inline picker now follows a new `value` from its parent.
- `blurredBackground` no longer blurs the whole screen behind an inline picker.
- The picker now scrolls when it does not fit, in portrait too, and a large `wheelHeight` no longer overflows.
- The iOS style picker with seconds no longer overflows on phones. The labels are now above the wheels.
- `accentColor` now applies to the buttons.
- `Ok` no longer calls a custom `onCancel`, and now closes the popup when one is provided. Before, the popup stayed open and `onCancel` also ran on each value change in `isOnChangeValueMode`.

### Docs

- Replaced the insecure and unreachable links of two contributors with their GitHub profiles.

## [0.0.1] - 6th November 2026.

- Initial release of `day_night_time_picker_plus` (v0.0.1).
- Migrated from the original package `day_night_time_picker`.
- Migrated all imports and components to modern Flutter `material_ui` (`package:material_ui/material_ui.dart`).
- Upgraded Dart SDK constraints to `^3.13.7` and Flutter SDK constraints to `>=3.0.0`.
- Added unit tests for Android and iOS style time pickers.
