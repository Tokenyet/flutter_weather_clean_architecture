import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/weather_info_model.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/weather_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late WeatherLocalDataSourceImpl weatherLocalDataSourceImpl;
  late SharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    weatherLocalDataSourceImpl = WeatherLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
  });

  group('WeatherLocalDataSourceImpl', () {
    group('getLastWeather', () {
      final tRawWeather = fixture('weather.json');
      final tWeatherModel = WeatherModel.fromJson(jsonDecode(tRawWeather));
      test(
          'return Weather from SharedPreference when there is one in the cache',
          () async {
        // arrange
        when(() => sharedPreferences.getString(any())).thenReturn(tRawWeather);
        // act
        final result = await weatherLocalDataSourceImpl.getLastWeather();
        // assert
        verify(() => sharedPreferences.getString(CACHED_WEATHER));
        expect(result, tWeatherModel);
      });

      test('throws CacheException when there is not a cache value', () async {
        // arrange
        when(() => sharedPreferences.getString(any())).thenReturn(null);
        // act
        final call = weatherLocalDataSourceImpl.getLastWeather();
        // assert
        expect(call, throwsA(isA<CacheException>()));
      });
    });
    group('getName', () {
      const tName = 'Taipei';
      test('return String from SharedPreference when there is one in the cache',
          () async {
        // arrange
        when(() => sharedPreferences.getString(any())).thenReturn(tName);
        // act
        final result = await weatherLocalDataSourceImpl.getLastName();
        // assert
        verify(() => sharedPreferences.getString(CACHED_LOCATION_NAME));
        expect(result, tName);
      });

      test('throws CacheException when there is not a cache value', () async {
        // arrange
        when(() => sharedPreferences.getString(any())).thenReturn(null);
        // act
        final call = weatherLocalDataSourceImpl.getLastWeather();
        // assert
        expect(call, throwsA(isA<CacheException>()));
      });
    });
    group('cacheWeather', () {
      final tWeather = WeatherModel(
        generationtimeMs: 1,
        longitude: 1,
        latitude: 2,
        elevation: 3,
        utcOffsetSeconds: 4,
        currentWeather: WeatherInfoModel(
          lastUpdated: DateTime(1),
          temperature: 1,
          windDirection: 2,
          windSpeed: 3,
          weatherCode: WeatherCode.clearSky,
        ),
      );
      final rawWeather = jsonEncode(tWeather.toJson());

      test('call SharedPreference to cache the data', () async {
        // act
        try {
          await weatherLocalDataSourceImpl.cacheWeather(tWeather);
        } catch (_) {}
        // assert
        verify(
          () => sharedPreferences.setString(CACHED_WEATHER, rawWeather),
        ).called(1);
      });
    });
    group('cacheName', () {
      const tName = 'test';
      test('call SharedPreference to cache the data', () async {
        // act
        try {
          await weatherLocalDataSourceImpl.cacheName(tName);
        } catch (_) {}
        // assert
        verify(
          () => sharedPreferences.setString(CACHED_LOCATION_NAME, tName),
        ).called(1);
      });
    });
  });
}
