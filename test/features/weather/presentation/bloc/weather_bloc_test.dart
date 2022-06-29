import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_clean_architecture/core/error/failures.dart';
import 'package:flutter_weather_clean_architecture/core/network/network_status.dart';
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
          location: tKeyword);
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
  });
}
