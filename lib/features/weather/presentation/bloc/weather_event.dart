part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherSearched extends WeatherEvent {
  final String keyword;
  const WeatherSearched({
    required this.keyword,
  });

  @override
  List<Object> get props => [super.props, keyword];
}
