import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
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

  group('GeoModel', () {
    group('fromJson', () {
      test('should return a valid model', () async {
        // arrange
        final jsonMap = jsonDecode(fixture('geo.json'));
        // act
        final result = GeoModel.fromJson(jsonMap);
        // assert
        expect(result, tGeoModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        // act
        final result = tGeoModel.toJson();
        // assert
        final expectedMap = {
          'id': 6602767,
          'name': "Taiwan Cypress",
          'latitude': 23.61556,
          'longitude': 120.8075,
          'elevation': 1893,
          'feature_code': "PRK",
          'country_code': "TW",
          'timezone': "Asia/Taipei",
          'country_id': 1668284,
          'country': "Taiwan",
        };

        expect(result, expectedMap);
      });
    });
  });
}
