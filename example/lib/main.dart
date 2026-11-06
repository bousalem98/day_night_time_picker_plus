import 'package:day_night_time_picker_plus/day_night_time_picker_plus.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeData _theme(Brightness brightness) => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: brightness,
    ),
    useMaterial3: true,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Day Night Time Picker Plus Demo',
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: _themeMode,
      home: HomePage(
        isDark: _themeMode == ThemeMode.dark,
        onDarkChanged: (isDark) => setState(() {
          _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
        }),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.isDark = false, this.onDarkChanged});

  final bool isDark;
  final ValueChanged<bool>? onDarkChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Time _time = Time(hour: 11, minute: 30, second: 20);
  bool _iosStyle = true;
  bool _is24Hr = false;
  bool _showSeconds = false;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  String get _formattedTime {
    String pad(int value) => value.toString().padLeft(2, '0');
    final hour = pad(_is24Hr ? _time.hour : _time.hourOfPeriod);
    final seconds = _showSeconds ? ':${pad(_time.second)}' : '';
    final period = _is24Hr ? '' : ' ${_time.period.name.toUpperCase()}';
    return '$hour:${pad(_time.minute)}$seconds$period';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Night Time Picker Plus'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Popup Picker Style', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    _formattedTime,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayMedium,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.access_time),
                    onPressed: () {
                      Navigator.of(context).push(
                        showPicker(
                          context: context,
                          value: _time,
                          onChange: onTimeChanged,
                          minuteInterval: TimePickerInterval.FIVE,
                          iosStylePicker: _iosStyle,
                          is24HrFormat: _is24Hr,
                          showSecondSelector: _showSeconds,
                          blurredBackground: true,
                          onChangeDateTime: (DateTime dateTime) {
                            debugPrint('[debug datetime]: $dateTime');
                          },
                        ),
                      );
                    },
                    label: const Text('Open Time Picker'),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Inline Picker Style',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  showPicker(
                    isInlinePicker: true,
                    elevation: 1,
                    value: _time,
                    onChange: onTimeChanged,
                    minuteInterval: TimePickerInterval.FIVE,
                    iosStylePicker: _iosStyle,
                    is24HrFormat: _is24Hr,
                    showSecondSelector: _showSeconds,
                    dialogInsetPadding: const EdgeInsets.all(8),
                    width: 340,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('iOS Style Picker'),
                    value: _iosStyle,
                    onChanged: (value) => setState(() => _iosStyle = value),
                  ),
                  SwitchListTile(
                    title: const Text('24 Hour Format'),
                    value: _is24Hr,
                    onChanged: (value) => setState(() => _is24Hr = value),
                  ),
                  SwitchListTile(
                    title: const Text('Seconds'),
                    value: _showSeconds,
                    onChanged: (value) => setState(() => _showSeconds = value),
                  ),
                  SwitchListTile(
                    title: const Text('Dark Theme'),
                    value: widget.isDark,
                    onChanged: widget.onDarkChanged,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
