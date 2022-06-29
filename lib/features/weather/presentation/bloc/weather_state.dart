part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  final NetworkStatus status;
  final String message;
  final Weather? weather;
  const WeatherState({
    this.status = NetworkStatus.init,
    this.message = '',
    this.weather,
  });

  @override
  List<Object?> get props => [status, message, weather];

  WeatherState copyWith({
    NetworkStatus? status,
    String? message,
    Weather? weather,
  }) {
    return WeatherState(
      status: status ?? this.status,
      message: message ?? this.message,
      weather: weather ?? this.weather,
    );
  }
}
