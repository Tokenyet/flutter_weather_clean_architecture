// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoModel _$GeoModelFromJson(Map<String, dynamic> json) => GeoModel(
      id: json['id'] as int,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
      featurCode: json['feature_code'] as String,
      countryCode: json['country_code'] as String,
      timezone: json['timezone'] as String,
      countryId: json['country_id'] as int,
      country: json['country'] as String,
    );

Map<String, dynamic> _$GeoModelToJson(GeoModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'elevation': instance.elevation,
      'feature_code': instance.featurCode,
      'country_code': instance.countryCode,
      'timezone': instance.timezone,
      'country_id': instance.countryId,
      'country': instance.country,
    };
