import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_weather_clean_architecture/core/error/failures.dart';
import 'package:flutter_weather_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/entities/weather.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/repositories/weather_repository.dart';

class GetForecastByName implements UseCase<Weather, GetForecastByNameParams> {
  final WeatherRepository weatherRepository;
  GetForecastByName({
    required this.weatherRepository,
  });

  @override
  Future<Either<Failure, Weather>> call(params) {
    return weatherRepository.getForecastByName(params.locationName);
  }
}

class GetForecastByNameParams extends Equatable {
  final String locationName;
  const GetForecastByNameParams({
    required this.locationName,
  });

  @override
  List<Object> get props => [locationName];
}
