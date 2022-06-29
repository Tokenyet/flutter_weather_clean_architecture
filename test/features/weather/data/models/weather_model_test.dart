import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/weather_info_model.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/weather_model.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  final tWeatherModel = WeatherModel(
    generationtimeMs: 0.34499168395996094,
    longitude: 13.419998,
    elevation: 38,
    currentWeather: WeatherInfoModel(
      lastUpdated: DateTime(2022, 06, 24, 08),
      temperature: 26.9,
      windDirection: 123,
      windSpeed: 14.6,
      weatherCode: WeatherCode.clearSky,
    ),
    latitude: 52.52,
    utcOffsetSeconds: 0,
  );

  group('WeatherModel', () {
    group('fromJson', () {
      test('should return a valid model', () async {
        // arrange
        final jsonMap = jsonDecode(fixture('weather.json'));
        // act
        final result = WeatherModel.fromJson(jsonMap);
        // assert
        expect(result, tWeatherModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        // act
        final result = tWeatherModel.toJson();
        // assert
        final expectedMap = {
          "generationtime_ms": 0.34499168395996094,
          "longitude": 13.419998,
          "elevation": 38,
          "current_weather": WeatherInfoModel(
            lastUpdated: DateTime(2022, 06, 24, 8),
            temperature: 26.9,
            weatherCode: WeatherCode.clearSky,
            windDirection: 123,
            windSpeed: 14.6,
          ),
          "utc_offset_seconds": 0,
          "latitude": 52.52
        };

        expect(result, expectedMap);
      });
    });
  });
}
