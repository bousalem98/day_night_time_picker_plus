import 'package:day_night_time_picker_plus/day_night_time_picker_plus.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Day Night Time Picker Plus Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Time _time = Time(hour: 11, minute: 30, second: 20);
  bool _iosStyle = true;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Popup Picker Style',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}:${_time.second.toString().padLeft(2, '0')} ${_time.period.name.toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    Navigator.of(context).push(
                      showPicker(
                        showSecondSelector: true,
                        context: context,
                        value: _time,
                        onChange: onTimeChanged,
                        minuteInterval: TimePickerInterval.FIVE,
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
                SizedBox(
                  width: 400,
                  child: showPicker(
                    isInlinePicker: true,
                    elevation: 1,
                    value: _time,
                    onChange: onTimeChanged,
                    minuteInterval: TimePickerInterval.FIVE,
                    iosStylePicker: _iosStyle,
                    minHour: 0,
                    maxHour: 23,
                    is24HrFormat: false,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('iOS Style Picker', style: theme.textTheme.bodyLarge),
                    const SizedBox(width: 8),
                    Switch(
                      value: _iosStyle,
                      onChanged: (newVal) {
                        setState(() {
                          _iosStyle = newVal;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
