import 'package:equatable/equatable.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/geo_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geo_collection_model.g.dart';

@JsonSerializable()
class GeoCollectionModel extends Equatable {
  const GeoCollectionModel({
    required this.results,
    required this.generationtimeMs,
  });

  @JsonKey(name: 'results', defaultValue: [])
  final List<GeoModel> results;
  @JsonKey(name: 'generationtime_ms')
  final double generationtimeMs;

  factory GeoCollectionModel.fromJson(Map<String, dynamic> json) =>
      _$GeoCollectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeoCollectionModelToJson(this);

  @override
  List<Object> get props {
    return [
      results,
      generationtimeMs,
    ];
  }
}
