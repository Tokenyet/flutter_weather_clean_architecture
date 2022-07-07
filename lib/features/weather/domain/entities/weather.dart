import 'package:equatable/equatable.dart';

// API:
// weatherState, time, min, max, current,
class Weather extends Equatable {
  final WeatherCondition condition;
  final DateTime lastUpdated;
  final String location;
  final double temperature;

  const Weather({
    required this.condition,
    required this.lastUpdated,
    required this.location,
    required this.temperature,
  });

  @override
  List<Object> get props => [condition, lastUpdated, location, temperature];
}

enum WeatherCondition {
  clear,
  snowy,
  rainy,
  cloudy,
  unknown,
}
