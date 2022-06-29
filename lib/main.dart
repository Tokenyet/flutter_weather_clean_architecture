import 'package:flutter/material.dart';
import 'package:flutter_weather_clean_architecture/app.dart';
import 'package:flutter_weather_clean_architecture/core/network/network_info.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/repositories/weather_repository.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // External
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final http.Client client = http.Client();
  final InternetConnectionChecker checker = InternetConnectionChecker();
  // Core
  final NetworkInfo networkInfo =
      NetworkInfoImpl(internetConnectionChecker: checker);
  // Feature
  final WeatherLocalDataSource weatherLocalDataSource =
      WeatherLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final WeatherRemoteDataSource weatherRemoteDataSource =
      WeatherRemoteDataSourceImpl(client: client);
  final WeatherRepository weatherRepository = WeatherRepositoryImpl(
    localDataSource: weatherLocalDataSource,
    remoteDataSource: weatherRemoteDataSource,
    networkInfo: networkInfo,
  );
  runApp(
    MainApp(weatherRepository: weatherRepository),
  );
}
