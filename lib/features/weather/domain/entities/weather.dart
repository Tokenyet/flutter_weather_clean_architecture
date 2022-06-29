import 'package:equatable/equatable.dart';

// API:
// weatherState, time, min, max, current,
class Weather extends Equatable {
  final WeatherCondition condition;
  final DateTime lastUpdated;
  final String location;

  const Weather({
    required this.condition,
    required this.lastUpdated,
    required this.location,
  });

  @override
  List<Object> get props => [condition, lastUpdated, location];
}

enum WeatherCondition {
  clear,
  snowy,
  rainy,
  cloudy,
  unknown,
}
