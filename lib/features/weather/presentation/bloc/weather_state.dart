part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  final NetworkStatus status;
  final String message;
  final Weather? weather;
  final TemperatureUnits units;
  const WeatherState({
    this.status = NetworkStatus.init,
    this.message = '',
    this.units = TemperatureUnits.celsius,
    this.weather,
  });

  @override
  List<Object?> get props => [status, message, weather, units];

  WeatherState copyWith({
    NetworkStatus? status,
    String? message,
    Weather? weather,
    TemperatureUnits? units,
  }) {
    return WeatherState(
      status: status ?? this.status,
      message: message ?? this.message,
      weather: weather ?? this.weather,
      units: units ?? this.units,
    );
  }
}
