import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_info_model.g.dart';

@JsonSerializable()
class WeatherInfoModel extends Equatable {
  const WeatherInfoModel({
    required this.lastUpdated,
    required this.temperature,
    required this.windDirection,
    required this.windSpeed,
    required this.weatherCode,
  });

  @JsonKey(name: 'time')
  final DateTime lastUpdated;
  @JsonKey(name: 'temperature')
  final double temperature;
  @JsonKey(name: 'winddirection')
  final double windDirection;
  @JsonKey(name: 'windspeed')
  final double windSpeed;
  @JsonKey(name: 'weathercode')
  final WeatherCode weatherCode;

  factory WeatherInfoModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherInfoModelToJson(this);

  @override
  List<Object> get props =>
      [lastUpdated, temperature, windDirection, windSpeed, weatherCode];
}

enum WeatherCode {
  @JsonValue(0)
  clearSky,
  @JsonValue(1)
  mainlyClear,
  @JsonValue(2)
  partlyCloud,
  @JsonValue(3)
  overcast,
  @JsonValue(45)
  fog,
  @JsonValue(48)
  heavyFog,
  @JsonValue(51)
  drizzleLight,
  @JsonValue(53)
  drizzleModerate,
  @JsonValue(55)
  drizzleDense,
  @JsonValue(56)
  freezeDrizzleLight,
  @JsonValue(57)
  freezeDrizzleDense,
  @JsonValue(61)
  rainLight,
  @JsonValue(63)
  rainModerate,
  @JsonValue(65)
  rainDense,
  @JsonValue(66)
  freezeRainLight,
  @JsonValue(67)
  freezeRainDense,
  @JsonValue(71)
  snowLight,
  @JsonValue(73)
  snowModerate,
  @JsonValue(75)
  snowHeavy,
  @JsonValue(77)
  snowGrain,
  @JsonValue(80)
  rainShowerLight,
  @JsonValue(81)
  rainShowerModerate,
  @JsonValue(82)
  rainShowerDense,
  @JsonValue(85)
  snowShowerLight,
  @JsonValue(86)
  snowShowerHeavy,
  @JsonValue(95)
  thunderStormLight,
  @JsonValue(99)
  thunderStormHailLight,
  @JsonValue(99)
  thunderStormHailHeavy,
}
