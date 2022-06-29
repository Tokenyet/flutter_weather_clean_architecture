import 'dart:convert';

import 'package:flutter_weather_clean_architecture/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_weather_clean_architecture/features/weather/data/models/geo_collection_model.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  /// Calls the https://geocoding-api.open-meteo.com/v1/search?name=[name]&count=1 endpoint
  ///
  /// Throws a [ServerException] for all error codes.
  Future<GeoCollectionModel> getGeoByKeyword(String keyword);

  /// Calls the https://api.open-meteo.com/v1/forecast?latitude=[lat]&longitude=[long]&timezone=UTC&current_weather=true endpoint
  ///
  /// Throws a [ServerException] for all error codes.
  Future<WeatherModel> getForecastByLongLat(double long, double lat);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  const WeatherRemoteDataSourceImpl({
    required this.client,
  });
  final http.Client client;

  @override
  Future<WeatherModel> getForecastByLongLat(double long, double lat) async {
    final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&timezone=UTC&current_weather=true');
    final headers = {'Content-Type': 'application/json'};
    final response = await client.get(
      uri,
      headers: headers,
    );

    if (response.statusCode != 200) throw ServerException();

    return WeatherModel.fromJson(jsonDecode(response.body));
  }

  @override
  Future<GeoCollectionModel> getGeoByKeyword(String keyword) async {
    final uri = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=$keyword&count=1');
    final headers = {'Content-Type': 'application/json'};
    final response = await client.get(
      uri,
      headers: headers,
    );

    if (response.statusCode != 200) throw ServerException();

    return GeoCollectionModel.fromJson(jsonDecode(response.body));
  }
}
