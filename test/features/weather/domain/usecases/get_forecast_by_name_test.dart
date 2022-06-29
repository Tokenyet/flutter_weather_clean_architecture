import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/entities/weather.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/repositories/weather_repository.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/usecases/get_forecast_by_name.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetForecastByName usecase;
  late WeatherRepository weatherRepository = MockWeatherRepository();
  setUp(() {
    weatherRepository = MockWeatherRepository();
    usecase = GetForecastByName(weatherRepository: weatherRepository);
  });

  const tlocationName = 'Taiwan';
  final tWeather = Weather(
    condition: WeatherCondition.unknown,
    lastUpdated: DateTime(1),
    location: tlocationName,
  );

  group('Usecase: GetForecastByName', () {
    test('should get forecast for weather from the repository', () async {
      // arrange
      when(() => weatherRepository.getForecastByName(any()))
          .thenAnswer((_) async => Right(tWeather));
      // act
      final result = await usecase(
        const GetForecastByNameParams(locationName: tlocationName),
      );
      // assert
      expect(result, Right(tWeather));
      verify(() => weatherRepository.getForecastByName(tlocationName));
      verifyNoMoreInteractions(weatherRepository);
    });
  });
}
