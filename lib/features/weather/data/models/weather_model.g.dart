// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
      generationtimeMs: (json['generationtime_ms'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
      utcOffsetSeconds: json['utc_offset_seconds'] as int,
      currentWeather: WeatherInfoModel.fromJson(
          json['current_weather'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'generationtime_ms': instance.generationtimeMs,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'elevation': instance.elevation,
      'utc_offset_seconds': instance.utcOffsetSeconds,
      'current_weather': instance.currentWeather,
    };
