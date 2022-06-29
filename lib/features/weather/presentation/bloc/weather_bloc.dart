import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_weather_clean_architecture/core/error/failures.dart';
import 'package:flutter_weather_clean_architecture/core/network/network_status.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/entities/weather.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/usecases/get_forecast_by_name.dart';

part 'weather_event.dart';
part 'weather_state.dart';

// ignore: constant_identifier_names
const CACHED_FAILURE_MESSAGE = 'Cache Failure';
// ignore: constant_identifier_names
const SERVER_FAILURE_MESSAGE = 'Server Failure';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({required this.getForecastByName}) : super(const WeatherState()) {
    on<WeatherSearched>(_onWeatherSearched);
  }
  final GetForecastByName getForecastByName;

  Future<void> _onWeatherSearched(
    WeatherSearched event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(status: NetworkStatus.loading));
    final failureOrWeather = await getForecastByName(
      GetForecastByNameParams(locationName: event.keyword),
    );
    failureOrWeather.fold((failure) {
      emit(
        state.copyWith(
          status: NetworkStatus.failure,
          message: failure.toMessage,
        ),
      );
    }, (weather) {
      emit(state.copyWith(status: NetworkStatus.success, weather: weather));
    });
  }
}

extension _FailureExtension on Failure {
  get toMessage {
    switch (runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
