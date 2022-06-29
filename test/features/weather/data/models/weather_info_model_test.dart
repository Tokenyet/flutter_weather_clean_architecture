import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/weather_info_model.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  final tWeatherInfoModel = WeatherInfoModel(
    lastUpdated: DateTime(2022, 06, 24, 08),
    temperature: 26.9,
    windDirection: 123,
    windSpeed: 14.6,
    weatherCode: WeatherCode.clearSky,
  );

  group('WeatherInfoModel', () {
    group('fromJson', () {
      test('should return a valid model', () async {
        // arrange
        final jsonMap = jsonDecode(fixture('weather_info.json'));
        // act
        final result = WeatherInfoModel.fromJson(jsonMap);
        // assert
        expect(result, tWeatherInfoModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        // act
        final result = tWeatherInfoModel.toJson();
        // assert
        final expectedMap = {
          "time": "2022-06-24T08:00:00.000",
          "temperature": 26.9,
          "winddirection": 123,
          "windspeed": 14.6,
          "weathercode": 0
        };

        expect(result, expectedMap);
      });
    });
  });
}
