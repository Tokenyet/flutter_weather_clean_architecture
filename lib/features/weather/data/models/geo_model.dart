import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geo_model.g.dart';

@JsonSerializable()
class GeoModel extends Equatable {
  const GeoModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.featurCode,
    required this.countryCode,
    required this.timezone,
    required this.countryId,
    required this.country,
  });

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;
  @JsonKey(name: 'elevation')
  final double elevation;
  @JsonKey(name: 'feature_code')
  final String featurCode;
  @JsonKey(name: 'country_code')
  final String countryCode;
  @JsonKey(name: 'timezone')
  final String timezone;
  @JsonKey(name: 'country_id')
  final int countryId;
  @JsonKey(name: 'country')
  final String country;

  factory GeoModel.fromJson(Map<String, dynamic> json) =>
      _$GeoModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeoModelToJson(this);

  @override
  List<Object> get props {
    return [
      id,
      name,
      latitude,
      longitude,
      elevation,
      featurCode,
      countryCode,
      timezone,
      countryId,
      country,
    ];
  }
}
