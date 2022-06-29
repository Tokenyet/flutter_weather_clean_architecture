// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherInfoModel _$WeatherInfoModelFromJson(Map<String, dynamic> json) =>
    WeatherInfoModel(
      lastUpdated: DateTime.parse(json['time'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      windDirection: (json['winddirection'] as num).toDouble(),
      windSpeed: (json['windspeed'] as num).toDouble(),
      weatherCode: $enumDecode(_$WeatherCodeEnumMap, json['weathercode']),
    );

Map<String, dynamic> _$WeatherInfoModelToJson(WeatherInfoModel instance) =>
    <String, dynamic>{
      'time': instance.lastUpdated.toIso8601String(),
      'temperature': instance.temperature,
      'winddirection': instance.windDirection,
      'windspeed': instance.windSpeed,
      'weathercode': _$WeatherCodeEnumMap[instance.weatherCode],
    };

const _$WeatherCodeEnumMap = {
  WeatherCode.clearSky: 0,
  WeatherCode.mainlyClear: 1,
  WeatherCode.partlyCloud: 2,
  WeatherCode.overcast: 3,
  WeatherCode.fog: 45,
  WeatherCode.heavyFog: 48,
  WeatherCode.drizzleLight: 51,
  WeatherCode.drizzleModerate: 53,
  WeatherCode.drizzleDense: 55,
  WeatherCode.freezeDrizzleLight: 56,
  WeatherCode.freezeDrizzleDense: 57,
  WeatherCode.rainLight: 61,
  WeatherCode.rainModerate: 63,
  WeatherCode.rainDense: 65,
  WeatherCode.freezeRainLight: 66,
  WeatherCode.freezeRainDense: 67,
  WeatherCode.snowLight: 71,
  WeatherCode.snowModerate: 73,
  WeatherCode.snowHeavy: 75,
  WeatherCode.snowGrain: 77,
  WeatherCode.rainShowerLight: 80,
  WeatherCode.rainShowerModerate: 81,
  WeatherCode.rainShowerDense: 82,
  WeatherCode.snowShowerLight: 85,
  WeatherCode.snowShowerHeavy: 86,
  WeatherCode.thunderStormLight: 95,
  WeatherCode.thunderStormHailLight: 99,
  WeatherCode.thunderStormHailHeavy: 99,
};
