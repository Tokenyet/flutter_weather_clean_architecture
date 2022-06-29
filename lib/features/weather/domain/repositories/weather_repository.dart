import 'package:dartz/dartz.dart';
import 'package:flutter_weather_clean_architecture/core/error/failures.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getForecastByName(String name);
}
