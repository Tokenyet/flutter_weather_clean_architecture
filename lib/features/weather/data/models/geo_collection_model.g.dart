// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoCollectionModel _$GeoCollectionModelFromJson(Map<String, dynamic> json) =>
    GeoCollectionModel(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => GeoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      generationtimeMs: (json['generationtime_ms'] as num).toDouble(),
    );

Map<String, dynamic> _$GeoCollectionModelToJson(GeoCollectionModel instance) =>
    <String, dynamic>{
      'results': instance.results,
      'generationtime_ms': instance.generationtimeMs,
    };
