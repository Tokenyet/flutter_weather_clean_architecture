import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/geo_collection_model.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

void main() {
  late WeatherRemoteDataSourceImpl weatherRemoteDataSourceImpl;
  late http.Client client;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    client = MockHttpClient();
    weatherRemoteDataSourceImpl = WeatherRemoteDataSourceImpl(client: client);
  });
  group('WeatherRemoteDataResourceImpl', () {
    group('getForecastByLongLat', () {
      const tLong = 1.0;
      const tLat = 2.0;
      final tWeatherModel =
          WeatherModel.fromJson(jsonDecode(fixture('weather.json')));
      test('''perform a GET request on a URL with number 
      being the endpoint and with application/json''', () async {
        // arrange
        final mockResponse = MockResponse();
        when(() => mockResponse.body).thenReturn(fixture('weather.json'));
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => mockResponse);
        // act
        try {
          await weatherRemoteDataSourceImpl.getForecastByLongLat(tLong, tLat);
        } catch (_) {}
        // assert
        verify(
          () => client.get(
            Uri.parse(
              'https://api.open-meteo.com/v1/forecast?latitude=$tLat&longitude=$tLong&timezone=UTC&current_weather=true',
            ),
            headers: {'Content-Type': 'application/json'},
          ),
        ).called(1);
      });

      test('return WeatherModel when the response code is 200 (success)',
          () async {
        // arrange
        final mockResponse = MockResponse();
        when(() => mockResponse.body).thenReturn(fixture('weather.json'));
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => mockResponse);
        // act
        final result =
            await weatherRemoteDataSourceImpl.getForecastByLongLat(tLong, tLat);
        // assert
        expect(result, tWeatherModel);
      });

      test('throws a ServerException when the response code is 404 or others',
          () async {
        // arrange
        final mockResponse = MockResponse();
        when(() => mockResponse.body).thenReturn('Any Data');
        when(() => mockResponse.statusCode).thenReturn(404);
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => mockResponse);
        // act
        final call =
            weatherRemoteDataSourceImpl.getForecastByLongLat(tLong, tLat);
        // assert
        expect(call, throwsA(isA<ServerException>()));
      });
    });

    group('getGeoByKeyword', () {
      const tKeyword = 'Taipei';
      final tGeoCollectionModel =
          GeoCollectionModel.fromJson(jsonDecode(fixture('geos.json')));
      test('''perform a GET request on a URL with number 
      being the endpoint and with application/json''', () async {
        // arrange
        final mockResponse = MockResponse();
        when(() => mockResponse.body).thenReturn(fixture('geos.json'));
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => mockResponse);
        // act
        try {
          await weatherRemoteDataSourceImpl.getGeoByKeyword(tKeyword);
        } catch (_) {}
        // assert
        verify(
          () => client.get(
            Uri.parse(
              'https://geocoding-api.open-meteo.com/v1/search?name=$tKeyword&count=1',
            ),
            headers: {'Content-Type': 'application/json'},
          ),
        ).called(1);
      });

      test('return GeoCollectionModel when the response code is 200 (success)',
          () async {
        // arrange
        final mockResponse = MockResponse();
        when(() => mockResponse.body).thenReturn(fixture('geos.json'));
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => mockResponse);
        // act
        final result =
            await weatherRemoteDataSourceImpl.getGeoByKeyword(tKeyword);
        // assert
        expect(result, tGeoCollectionModel);
      });

      test('throws a ServerException when the response code is 404 or others',
          () async {
        // arrange
        final mockResponse = MockResponse();
        when(() => mockResponse.body).thenReturn('Any Data');
        when(() => mockResponse.statusCode).thenReturn(404);
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => mockResponse);
        // act
        final call = weatherRemoteDataSourceImpl.getGeoByKeyword(tKeyword);
        // assert
        expect(call, throwsA(isA<ServerException>()));
      });
    });
  });
}
