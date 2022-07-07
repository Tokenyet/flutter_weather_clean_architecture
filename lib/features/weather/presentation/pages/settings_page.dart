import 'package:flutter/material.dart';
import 'package:flutter_weather_clean_architecture/core/presentation/temperature_units.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.units}) : super(key: key);
  final TemperatureUnits units;
  static Route<TemperatureUnits> route(TemperatureUnits units) {
    return MaterialPageRoute<TemperatureUnits>(
      builder: (_) => SettingsPage(
        units: units,
      ),
    );
  }

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TemperatureUnits units;
  @override
  void initState() {
    units = widget.units;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(units);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Temperature Units'),
              isThreeLine: true,
              subtitle: const Text(
                'Use metric measurements for temperature units.',
              ),
              trailing: Switch(
                value: units.isCelsius,
                onChanged: (_) {
                  if (units.isCelsius) {
                    setState(() {
                      units = TemperatureUnits.fahrenheit;
                    });
                  } else {
                    setState(() {
                      units = TemperatureUnits.celsius;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
