import 'dart:convert';

import 'package:flutter_weather_clean_architecture/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_weather_clean_architecture/features/weather/data/models/weather_model.dart';

abstract class WeatherLocalDataSource {
  /// Get the cached [WeatherModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws a [CacheException] If no cached data is present.
  Future<WeatherModel> getLastWeather();

  /// Get the cached name which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws a [CacheException] If no cached data is present.
  Future<String> getLastName();

  Future<void> cacheWeather(WeatherModel weatherToCache);
  Future<void> cacheName(String name);
}

// ignore: constant_identifier_names
const CACHED_WEATHER = 'CACHED_WEATHER';
// ignore: constant_identifier_names
const CACHED_LOCATION_NAME = 'CACHED_LOCATION_NAME';

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;
  const WeatherLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheName(String name) {
    return sharedPreferences.setString(
      CACHED_LOCATION_NAME,
      name,
    );
  }

  @override
  Future<void> cacheWeather(WeatherModel weatherToCache) {
    return sharedPreferences.setString(
      CACHED_WEATHER,
      jsonEncode(weatherToCache.toJson()),
    );
  }

  @override
  Future<WeatherModel> getLastWeather() async {
    final raw = sharedPreferences.getString(CACHED_WEATHER);
    if (raw == null) throw CacheException();
    final weatherModel = WeatherModel.fromJson(jsonDecode(raw));
    return weatherModel;
  }

  @override
  Future<String> getLastName() async {
    final raw = sharedPreferences.getString(CACHED_LOCATION_NAME);
    if (raw == null) throw CacheException();
    return raw;
  }
}
