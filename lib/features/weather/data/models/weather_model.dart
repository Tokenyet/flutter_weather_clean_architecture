import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_weather_clean_architecture/features/weather/data/models/weather_info_model.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel extends Equatable {
  const WeatherModel({
    required this.generationtimeMs,
    required this.longitude,
    required this.latitude,
    required this.elevation,
    required this.utcOffsetSeconds,
    required this.currentWeather,
  });

  @JsonKey(name: 'generationtime_ms')
  final double generationtimeMs;
  @JsonKey(name: 'longitude')
  final double longitude;
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'elevation')
  final double elevation;
  @JsonKey(name: 'utc_offset_seconds')
  final int utcOffsetSeconds;
  @JsonKey(name: 'current_weather')
  final WeatherInfoModel currentWeather;

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  @override
  List<Object> get props {
    return [
      generationtimeMs,
      longitude,
      latitude,
      elevation,
      utcOffsetSeconds,
      currentWeather,
    ];
  }
}
