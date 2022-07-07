import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_clean_architecture/core/error/failures.dart';
import 'package:flutter_weather_clean_architecture/core/network/network_status.dart';
import 'package:flutter_weather_clean_architecture/core/presentation/temperature_units.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/entities/weather.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/usecases/get_forecast_by_name.dart';
import 'package:flutter_weather_clean_architecture/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetForecastByName extends Mock implements GetForecastByName {}

void main() {
  late WeatherBloc bloc;
  late GetForecastByName getForecastByName;

  setUpAll(() {
    registerFallbackValue(const GetForecastByNameParams(locationName: ''));
  });

  setUp(() {
    getForecastByName = MockGetForecastByName();
    bloc = WeatherBloc(getForecastByName: getForecastByName);
  });

  group('WeatherBloc', () {
    test('initialState is correct', () {
      expect(
        WeatherBloc(getForecastByName: getForecastByName).state,
        const WeatherState(),
      );
    });

    group('WeatherSearched', () {
      const tKeyword = 'Taipei';
      final tWeather = Weather(
        condition: WeatherCondition.clear,
        lastUpdated: DateTime(1),
        location: tKeyword,
        temperature: 28.0,
      );
      test('get data from getForecastByNameUse ', () async {
        // arrange
        when(() => getForecastByName(any()))
            .thenAnswer((_) async => Right(tWeather));
        // act
        bloc.add(const WeatherSearched(keyword: tKeyword));
        await bloc.close();
        // assert
        verify(
          () => getForecastByName(
            const GetForecastByNameParams(locationName: tKeyword),
          ),
        ).called(1);
      });

      test('emits [loading, success] when data is gotten successfully',
          () async {
        // arrange
        when(() => getForecastByName(any()))
            .thenAnswer((_) async => Right(tWeather));
        // assert later
        expect(
          bloc.stream,
          emitsInOrder(
            [
              const WeatherState(status: NetworkStatus.loading),
              WeatherState(status: NetworkStatus.success, weather: tWeather),
            ],
          ),
        );
        // act
        bloc.add(const WeatherSearched(keyword: tKeyword));
        await bloc.close();
      });

      test('emits [loading, failure] when getting data fails', () async {
        // arrange
        when(() => getForecastByName(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        expect(
          bloc.stream,
          emitsInOrder(
            [
              const WeatherState(status: NetworkStatus.loading),
              const WeatherState(
                status: NetworkStatus.failure,
                message: SERVER_FAILURE_MESSAGE,
              ),
            ],
          ),
        );
        // act
        bloc.add(const WeatherSearched(keyword: tKeyword));
        await bloc.close();
      });

      test(
          'emits [loading, failure] with a proper message for the error when getting data fails',
          () async {
        // arrange
        when(() => getForecastByName(any()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        expect(
          bloc.stream,
          emitsInOrder(
            [
              const WeatherState(status: NetworkStatus.loading),
              const WeatherState(
                status: NetworkStatus.failure,
                message: CACHED_FAILURE_MESSAGE,
              ),
            ],
          ),
        );
        // act
        bloc.add(const WeatherSearched(keyword: tKeyword));
        await bloc.close();
      });
    });

    group('WeatherUnitChanged', () {
      final tWeather = Weather(
        condition: WeatherCondition.clear,
        lastUpdated: DateTime(1),
        location: 'Taipei',
        temperature: 28.0,
      );
      final tWeatherForFahrenheit = Weather(
        condition: WeatherCondition.clear,
        lastUpdated: DateTime(1),
        location: 'Taipei',
        temperature: 5.0,
      );
      test('change unit for state', () async {
        // assert later
        expect(
          bloc.stream,
          emitsInOrder(
            [
              const WeatherState(
                units: TemperatureUnits.fahrenheit,
              ),
            ],
          ),
        );
        // act
        bloc.add(const WeatherUnitChanged(
          units: TemperatureUnits.fahrenheit,
        ));
        await bloc.close();
      });

      test('temperature changed for fahrenheit', () async {
        // arrange
        when(() => getForecastByName(any()))
            .thenAnswer((_) async => Right(tWeather));
        // assert later
        expect(
          bloc.stream,
          emitsInOrder(
            [
              const WeatherState(status: NetworkStatus.loading),
              WeatherState(status: NetworkStatus.success, weather: tWeather),
              WeatherState(
                status: NetworkStatus.success,
                units: TemperatureUnits.fahrenheit,
                weather: Weather(
                  condition: tWeather.condition,
                  lastUpdated: tWeather.lastUpdated,
                  location: tWeather.location,
                  temperature: tWeather.temperature.toFahrenheit(),
                ),
              ),
            ],
          ),
        );
        // act
        bloc.add(const WeatherSearched(keyword: 'Taipei'));
        bloc.add(const WeatherUnitChanged(
          units: TemperatureUnits.fahrenheit,
        ));
        await bloc.close();
      });

      test('temperature changed for celsius', () async {
        // arrange
        when(() => getForecastByName(any()))
            .thenAnswer((_) async => Right(tWeatherForFahrenheit));
        // assert later
        expect(
          bloc.stream,
          emitsInOrder(
            [
              const WeatherState(status: NetworkStatus.loading),
              WeatherState(
                  status: NetworkStatus.success,
                  weather: tWeatherForFahrenheit),
              WeatherState(
                status: NetworkStatus.success,
                units: TemperatureUnits.fahrenheit,
                weather: Weather(
                  condition: tWeatherForFahrenheit.condition,
                  lastUpdated: tWeatherForFahrenheit.lastUpdated,
                  location: tWeatherForFahrenheit.location,
                  temperature: tWeatherForFahrenheit.temperature.toFahrenheit(),
                ),
              ),
              WeatherState(
                status: NetworkStatus.success,
                units: TemperatureUnits.celsius,
                weather: Weather(
                  condition: tWeatherForFahrenheit.condition,
                  lastUpdated: tWeatherForFahrenheit.lastUpdated,
                  location: tWeatherForFahrenheit.location,
                  temperature: tWeatherForFahrenheit.temperature,
                ),
              ),
            ],
          ),
        );
        // act
        bloc.add(const WeatherSearched(keyword: 'Taipei'));
        bloc.add(const WeatherUnitChanged(
          units: TemperatureUnits.fahrenheit,
        ));
        bloc.add(const WeatherUnitChanged(
          units: TemperatureUnits.celsius,
        ));
        await bloc.close();
      });
    });
  });
}

extension on double {
  double toFahrenheit() => ((this * 9 / 5) + 32);
  // double toCelsius() => ((this - 32) * 5 / 9);
}
