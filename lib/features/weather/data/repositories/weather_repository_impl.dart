import 'package:dartz/dartz.dart';

import 'package:flutter_weather_clean_architecture/core/error/failures.dart';
import 'package:flutter_weather_clean_architecture/core/network/network_info.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/weather_info_model.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/entities/weather.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, Weather>> getForecastByName(String name) async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final geos = await remoteDataSource.getGeoByKeyword(name);
        if (geos.results.isEmpty) return Left(ServerFailure());
        final firstGeo = geos.results.first;
        final forecastWeather = await remoteDataSource.getForecastByLongLat(
            firstGeo.longitude, firstGeo.latitude);
        await localDataSource.cacheWeather(forecastWeather);
        await localDataSource.cacheName(name);
        final weather = Weather(
          condition: forecastWeather.currentWeather.weatherCode.toCondition,
          lastUpdated: forecastWeather.currentWeather.lastUpdated,
          location: firstGeo.name,
        );
        return Right(weather);
      } catch (_) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final name = await localDataSource.getLastName();
        final weatherModel = await localDataSource.getLastWeather();

        final weather = Weather(
          condition: weatherModel.currentWeather.weatherCode.toCondition,
          lastUpdated: weatherModel.currentWeather.lastUpdated,
          location: name,
        );

        return Right(weather);
      } catch (_) {
        return Left(CacheFailure());
      }
    }
  }
}

extension WeatherCodeExtension on WeatherCode {
  WeatherCondition get toCondition {
    switch (this) {
      case WeatherCode.clearSky:
      case WeatherCode.mainlyClear:
        return WeatherCondition.clear;
      case WeatherCode.partlyCloud:
      case WeatherCode.overcast:
      case WeatherCode.fog:
      case WeatherCode.heavyFog:
        return WeatherCondition.cloudy;
      case WeatherCode.drizzleLight:
      case WeatherCode.drizzleModerate:
      case WeatherCode.drizzleDense:
        return WeatherCondition.rainy;
      case WeatherCode.freezeDrizzleLight:
      case WeatherCode.freezeDrizzleDense:
        return WeatherCondition.snowy;
      case WeatherCode.rainLight:
      case WeatherCode.rainModerate:
      case WeatherCode.rainDense:
        return WeatherCondition.rainy;
      case WeatherCode.freezeRainLight:
      case WeatherCode.freezeRainDense:
        return WeatherCondition.snowy;
      case WeatherCode.snowLight:
      case WeatherCode.snowModerate:
      case WeatherCode.snowHeavy:
      case WeatherCode.snowGrain:
        return WeatherCondition.snowy;
      case WeatherCode.rainShowerLight:
      case WeatherCode.rainShowerModerate:
      case WeatherCode.rainShowerDense:
        return WeatherCondition.rainy;
      case WeatherCode.snowShowerLight:
      case WeatherCode.snowShowerHeavy:
        return WeatherCondition.snowy;
      case WeatherCode.thunderStormLight:
      case WeatherCode.thunderStormHailLight:
      case WeatherCode.thunderStormHailHeavy:
        return WeatherCondition.rainy;
      default:
        return WeatherCondition.unknown;
    }
  }
}
