import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/geo_collection_model.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/geo_model.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  const tGeoModel = GeoModel(
    id: 6602767,
    name: "Taiwan Cypress",
    latitude: 23.61556,
    longitude: 120.8075,
    elevation: 1893,
    featurCode: "PRK",
    countryCode: "TW",
    timezone: "Asia/Taipei",
    countryId: 1668284,
    country: "Taiwan",
  );
  const tGeoCollectionModel = GeoCollectionModel(
    generationtimeMs: 0.41007996,
    results: [tGeoModel],
  );
  const tEmptyGeoCollectionModel = GeoCollectionModel(
    generationtimeMs: 0.18799305,
    results: [],
  );

  group('GeoCollectionModel', () {
    group('fromJson', () {
      test('should return a valid model', () async {
        // arrange
        final jsonMap = jsonDecode(fixture('geos.json'));
        // act
        final result = GeoCollectionModel.fromJson(jsonMap);
        // assert
        expect(result, tGeoCollectionModel);
      });

      test('should return a valid model without results for empty', () async {
        // arrange
        final jsonMap = jsonDecode(fixture('geos_empty.json'));
        // act
        final result = GeoCollectionModel.fromJson(jsonMap);
        // assert
        expect(result, tEmptyGeoCollectionModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        // act
        final result = tGeoCollectionModel.toJson();
        // assert
        final expectedMap = {
          'results': [tGeoModel],
          'generationtime_ms': 0.41007996,
        };

        expect(result, expectedMap);
      });
    });
  });
}
