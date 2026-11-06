# DayNightTimePicker Plus

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-26-orange.svg?style=flat)](#contributors)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

> **Note**: This package is migrated from the original [`day_night_time_picker`](https://pub.dev/packages/day_night_time_picker) package to support the latest Flutter SDK and modern [`material_ui`](https://pub.dev/packages/material_ui) design package.

A day night time picker for Flutter with beautiful day and night animations.

> ### Default style:
>
> <img src="https://raw.githubusercontent.com/bousalem98/day_night_time_picker_plus/master/example.gif" style="width: 100%; max-width: 400px; height: auto" />

<br />
<br />

> ### IOS style:
>
> <img src="https://raw.githubusercontent.com/bousalem98/day_night_time_picker_plus/master/example_ios_style.png" style="width: 100%; max-width: 400px; height: auto" />

<br />
<br />

> ### [View it on pub.dev](https://pub.dev/packages/day_night_time_picker_plus)

---

## Installation

Add to pubspec.yaml.

```yaml
dependencies:
  day_night_time_picker_plus:
```

---

## Usage

To use plugin, just import package

```dart
import 'package:day_night_time_picker_plus/day_night_time_picker_plus.dart';
```

---

## Example

```dart
TextButton(
    onPressed: () {
        Navigator.of(context).push(
            showPicker(
                context: context,
                value: _time,
                sunrise: TimeOfDay(hour: 6, minute: 0), // optional
                sunset: TimeOfDay(hour: 18, minute: 0), // optional
                duskSpanInMinutes: 120, // optional
                onChange: onTimeChanged,
            ),
        );
    },
    child: Text(
        "Open time picker",
        style: TextStyle(color: Colors.white),
    ),
),
```

---

## Props

| Name                            | Description                                                                                                                        |                         Default                          |
| :------------------------------ | :--------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------: |
| **value**                       | **`Required`** Display value. It takes in [Time].                                                                                  |                                                          |
| **onChange**                    | **`Required`** Return the new time the user picked as [Time].                                                                      |                                                          |
| **isInlinePicker**              | Whether to render an inline widget.                                                                                                |                         `false`                          |
| **onChangeDateTime**            | _`Optional`_ Return the new time the user picked as [DateTime].                                                                    |                                                          |
| **onCancel**                    | _`Optional`_ Custom callback for the Cancel button. Note: if provided, it will override the default behavior of the Cancel button, so closing the picker is up to the callback. The Ok button is not affected. |                                                          |
| **is24HrFormat**                | Show the time in TimePicker in 24 hour format.                                                                                     |                         `false`                          |
| **accentColor**                 | Accent color of the TimePicker.                                                                                                    | `Theme.of(context).colorScheme.primary` |
| **unselectedColor**             | Color applied unselected options (am/pm, hour/minute).                                                                             | `Theme.of(context).colorScheme.onSurfaceVariant` |
| **cancelText**                  | Text displayed for the Cancel button.                                                                                              | `Cancel` |
| **okText**                      | Text displayed for the Ok button.                                                                                                  | `Ok` |
| **sunAsset**                    | Image asset used for the Sun.                                                                                                      |                      Asset provided                      |
| **moonAsset**                   | Image asset used for the Moon.                                                                                                     |                      Asset provided                      |
| **blurredBackground**           | Whether to blur the background of the [Modal].                                                                                     |                         `false`                          |
| **barrierColor**                | Color of the background of the [Modal].                                                                                            |                     `Colors.black45`                     |
| **borderRadius**                | Border radius of the [Container] in [double].                                                                                      | `24.0` |
| **elevation**                   | Elevation of the [Modal] in [double].                                                                                              |                          `12.0`                          |
| **dialogInsetPadding**          | Inset padding of the [Modal] in EdgeInsets.                                                                                        | `EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0)` |
| **barrierDismissible**          | Whether clicking outside should dismiss the [Modal].                                                                               |                          `true`                          |
| **showCancelButton**            | Whether to show the cancel button or not                                                                                           |                          `true`                          |
| **iosStylePicker**              | Whether to display a IOS style picker (Not exactly the same).                                                                      |                         `false`                          |
| **hourLabel**                   | The label to be displayed for `hour` picker. Only for _iosStylePicker_.                                                            |                        `'hours'`                         |
| **minuteLabel**                 | The label to be displayed for `minute` picker. Only for _iosStylePicker_.                                                          |                       `'minutes'`                        |
| **minuteInterval**              | Steps interval while changing `minute`. Accepts `TimePickerInterval` enum.                                                         |                 `TimePickerInterval.ONE`                 |
| **secondInterval**              | Steps interval while changing `second`. Accepts `TimePickerInterval` enum.                                                         |                 `TimePickerInterval.ONE`                 |
| **disableMinute**               | Disables the minute picker.                                                                                                        |                         `false`                          |
| **disableHour**                 | Disables the hour picker.                                                                                                          |                         `false`                          |
| **minHour**                     | Selectable minimum hour.                                                                                                           | `0` |
| **maxHour**                     | Selectable maximum hour.                                                                                                           | `23` |
| **minMinute**                   | Selectable minimum minute.                                                                                                         |                           `0`                            |
| **minSecond**                   | Selectable minimum second.                                                                                                         |                           `0`                            |
| **maxMinute**                   | Selectable maximum minute.                                                                                                         |                           `59`                           |
| **maxSecond**                   | Selectable maximum second.                                                                                                         |                           `59`                           |
| **displayHeader**               | Whether to display the sun moon animation.                                                                                         |                          `true`                          |
| **isOnValueChangeMode**         | Whether to hide okText, cancelText and return value on every onValueChange. **_Only for Inline widget_**                           |                         `false`                          |
| **focusMinutePicker**           | Whether or not the minute picker is auto focus/selected.                                                                           |                         `false`                          |
| **backgroundColor**             | Background color of the picker.                                                                                                    |                 `colorScheme.surface`                    |
| **themeData**                   | ThemeData to use for the widget.                                                                                                   |                   `Theme.of(context)`                    |
| **okStyle**                     | Ok button's text style.                                                                                                            |      `const TextStyle(fontWeight: FontWeight.bold)`      |
| **cancelStyle**                 | Cancel button's text style.                                                                                                        |      `const TextStyle(fontWeight: FontWeight.bold)`      |
| **buttonStyle**                 | Button's style. If `cancelButtonStyle` not provided, it applies to ok and cancel buttons.                                          | Filled `Ok` button and text `Cancel` button in the accent colors |
| **cancelButtonStyle**           | Cancel button style.                                                                                                               | Text button in the unselected color |
| **buttonsSpacing**              | Spacing between cancel and ok buttons.                                                                                             | `8` |
| **wheelHeight**                 | Only for _iosStylePicker_. Height of the Wheel                                                                                  | `120` |
| **hideButtons**                 | Whether to hide the buttons (ok and cancel).                                                                                       |                         `false`                          |
| **disableAutoFocusToNextInput** | Whether to disable the auto focus to the next input after current input is selected.                                               |                         `false`                          |
| **width**                       | Maximum width of the Picker container.                                                                                               |                `300` (`350` for iosStyle)                |
| **height**                      | Minimum height of the content below the sky.                                                                                              | `260`, grows with the content |
| **sunrise**                     | Time at which the sun rises and the moon sets in the sky.                                                                                                                      | `TimeOfDay(hour: 6, minute: 0)` |
| **sunset**                      | Time at which the sun sets and the moon rises in the sky.                                                                                                                       | `TimeOfDay(hour: 18, minute: 0)` |
| **duskSpanInMinutes**           | How long before the sunset the sky starts turning into dusk.                                                                                                              | `120` |
| **settings**                    | _`Optional`_ Data that might be useful in constructing a [Route].                                                                  |                                                          |

---

## Contributors

Thanks goes to these wonderful people:

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/bousalem98"><img src="https://avatars.githubusercontent.com/u/61710794?v=4" width="100px;" alt="Mohamed Salem"/><br /><sub><b>Mohamed Salem</b></sub></a><br /><a href="https://github.com/bousalem98/day_night_time_picker_plus/commits?author=bousalem98" title="Code">💻</a> <a href="https://github.com/bousalem98/day_night_time_picker_plus/commits?author=bousalem98" title="Documentation">📖</a> <a href="#maintenance-bousalem98" title="Maintenance">🚧</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/subhamayd2"><img src="https://avatars.githubusercontent.com/u/23093995?v=4?s=100" width="100px;" alt="Subhamay Dutta"/><br /><sub><b>Subhamay Dutta</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=subhamayd2" title="Code">💻</a> <a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=subhamayd2" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/impure"><img src="https://avatars.githubusercontent.com/u/4359114?v=4?s=100" width="100px;" alt="Andrew Zuo"/><br /><sub><b>Andrew Zuo</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=impure" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/oude-mohammad/"><img src="https://avatars.githubusercontent.com/u/6555426?v=4?s=100" width="100px;" alt="Mohammad Odeh"/><br /><sub><b>Mohammad Odeh</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=MOOUDE" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/hashem78"><img src="https://avatars.githubusercontent.com/u/4525797?v=4?s=100" width="100px;" alt="Hashem Alayan"/><br /><sub><b>Hashem Alayan</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=hashem78" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/gohdong"><img src="https://avatars.githubusercontent.com/u/22044475?v=4?s=100" width="100px;" alt="gohdong"/><br /><sub><b>gohdong</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=gohdong" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://achim.io/"><img src="https://avatars.githubusercontent.com/u/43643339?v=4?s=100" width="100px;" alt="nohli"/><br /><sub><b>nohli</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=nohli" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/sander102907"><img src="https://avatars.githubusercontent.com/u/22891388?v=4?s=100" width="100px;" alt="sander102907"/><br /><sub><b>sander102907</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=sander102907" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://asoteam.ir"><img src="https://avatars.githubusercontent.com/u/22625638?v=4?s=100" width="100px;" alt="Sobhan Moradi"/><br /><sub><b>Sobhan Moradi</b></sub></a><br /><a href="#design-sobimor" title="Design">🎨</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/iaskari"><img src="https://avatars.githubusercontent.com/u/3792357?v=4?s=100" width="100px;" alt="Omar Dahhane"/><br /><sub><b>Omar Dahhane</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=iaskari" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/fatihy101"><img src="https://avatars.githubusercontent.com/u/34458068?v=4?s=100" width="100px;" alt="Fatih Yaman"/><br /><sub><b>Fatih Yaman</b></sub></a><br /><a href="#design-fatihy101" title="Design">🎨</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.awesomejerry.space"><img src="https://avatars.githubusercontent.com/u/6601073?v=4?s=100" width="100px;" alt="JerryShen"/><br /><sub><b>JerryShen</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=awesomejerry" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/morio77"><img src="https://avatars.githubusercontent.com/u/68191253?v=4?s=100" width="100px;" alt="本多健也"/><br /><sub><b>本多健也</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=morio77" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/TheGlorySaint"><img src="https://avatars.githubusercontent.com/u/21318321?v=4?s=100" width="100px;" alt="Tempelritter"/><br /><sub><b>Tempelritter</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=TheGlorySaint" title="Code">💻</a> <a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=TheGlorySaint" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Silfalion"><img src="https://avatars.githubusercontent.com/u/23188369?v=4?s=100" width="100px;" alt="Silfalion"/><br /><sub><b>Silfalion</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=Silfalion" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/guchengxi1994"><img src="https://avatars.githubusercontent.com/u/33513462?v=4?s=100" width="100px;" alt="Chengxi Gu"/><br /><sub><b>Chengxi Gu</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=guchengxi1994" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.saifbillah.com"><img src="https://avatars.githubusercontent.com/u/23041420?v=4?s=100" width="100px;" alt="Saif Billah"/><br /><sub><b>Saif Billah</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=saifb" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/markszente"><img src="https://avatars.githubusercontent.com/u/29143275?v=4?s=100" width="100px;" alt="Mark Szente"/><br /><sub><b>Mark Szente</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=markszente" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://linkedin.com/in/rcjuancarlosuwu"><img src="https://avatars.githubusercontent.com/u/67658540?v=4?s=100" width="100px;" alt="Juan Carlos Ramón Condezo"/><br /><sub><b>Juan Carlos Ramón Condezo</b></sub></a><br /><a href="#design-rcjuancarlosuwu" title="Design">🎨</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Likenttt"><img src="https://avatars.githubusercontent.com/u/26034018?v=4?s=100" width="100px;" alt="Chuanyi"/><br /><sub><b>Chuanyi</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=Likenttt" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/leonschwanitz"><img src="https://avatars.githubusercontent.com/u/36971798?v=4?s=100" width="100px;" alt="Leon Schwanitz"/><br /><sub><b>Leon Schwanitz</b></sub></a><br /><a href="#design-leonschwanitz" title="Design">🎨</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/elmdecoste"><img src="https://avatars.githubusercontent.com/u/1967150?v=4?s=100" width="100px;" alt="Liam DeCoste"/><br /><sub><b>Liam DeCoste</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/issues?q=author%3Aelmdecoste" title="Bug reports">🐛</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/qqjjjj"><img src="https://avatars.githubusercontent.com/u/67450840?v=4?s=100" width="100px;" alt="qqjjjj"/><br /><sub><b>qqjjjj</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=qqjjjj" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/moshe5745"><img src="https://avatars.githubusercontent.com/u/7037149?v=4?s=100" width="100px;" alt="Moshe Yamini"/><br /><sub><b>Moshe Yamini</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=moshe5745" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/naipaka"><img src="https://avatars.githubusercontent.com/u/45661924?v=4?s=100" width="100px;" alt="Ryota Kobayashi"/><br /><sub><b>Ryota Kobayashi</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=naipaka" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Emon526"><img src="https://avatars.githubusercontent.com/u/57067036?v=4?s=100" width="100px;" alt="Asraful Islam"/><br /><sub><b>Asraful Islam</b></sub></a><br /><a href="https://github.com/subhamayd2/day_night_time_picker_plus/commits?author=Emon526" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

---

## LICENCE

```
Copyright 2026 Mohamed Salem
Copyright 2023 Subhamay Dutta

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
