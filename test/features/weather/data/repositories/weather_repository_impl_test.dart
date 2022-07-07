import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_weather_clean_architecture/core/error/failures.dart';
import 'package:flutter_weather_clean_architecture/core/network/network_info.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/geo_collection_model.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/geo_model.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/weather_info_model.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/models/weather_model.dart';
import 'package:flutter_weather_clean_architecture/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/entities/weather.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

class MockWeatherLocalDataSource extends Mock
    implements WeatherLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockGeoCollectionModel extends Mock implements GeoCollectionModel {}

class MockGeoModel extends Mock implements GeoModel {}

class MockWeatherModel extends Mock implements WeatherModel {}

class MockWeatherInfoModel extends Mock implements WeatherInfoModel {}

void main() {
  late WeatherRepositoryImpl repository;
  late WeatherRemoteDataSource remoteDataSource;
  late WeatherLocalDataSource localDataSource;
  late NetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockWeatherRemoteDataSource();
    localDataSource = MockWeatherLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = WeatherRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });
  group('WeatherRepositoryImpl', () {
    group('getForecastByName', () {
      const tName = 'Taipei';
      const tLongitude = 1.0;
      const tLatitude = 2.0;
      const tWeatherCode = WeatherCode.clearSky;
      const tTemperature = 28.0;
      final tLastUpdated = DateTime(2022, 06, 24, 08);
      final tWeather = Weather(
        condition: WeatherCondition.clear,
        lastUpdated: tLastUpdated,
        location: tName,
        temperature: tTemperature,
      );
      test('check If the device is online', () async {
        // arrange
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        try {
          // act
          await repository.getForecastByName(tName);
        } catch (_) {
          // assert
          verify(() => networkInfo.isConnected);
        }
      });

      group('device is online', () {
        setUp(() {
          when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        });

        test('call getGeoByKeyword with correct keyword', () async {
          // arrange
          try {
            // act
            await repository.getForecastByName(tName);
          } catch (_) {
            // assert
            verify(() => remoteDataSource.getGeoByKeyword(tName)).called(1);
          }
        });

        test('return server failure when getGeoByKeyword throws', () async {
          // arrange
          final exception = Exception('oops!');
          when(() => remoteDataSource.getGeoByKeyword(any()))
              .thenThrow(exception);
          // act
          final result = await repository.getForecastByName(tName);
          // assert
          expect(result, Left(ServerFailure()));
        });

        test('return server failure when getGeoByKeyword has no results',
            () async {
          // arrange
          final mockGeoCollectionModel = MockGeoCollectionModel();
          final mockGeoModels = <GeoModel>[];
          when(() => mockGeoCollectionModel.results).thenReturn(mockGeoModels);
          when(() => remoteDataSource.getGeoByKeyword(tName))
              .thenAnswer((_) async => mockGeoCollectionModel);
          // act
          final result = await repository.getForecastByName(tName);
          // assert
          expect(result, Left(ServerFailure()));
        });

        test('call getForecastByLongLat with correct long and lat', () async {
          // arrange
          final mockGeoCollectionModel = MockGeoCollectionModel();
          final mockGeoModel = MockGeoModel();
          final mockGeoModels = [mockGeoModel];
          when(() => mockGeoModel.longitude).thenReturn(tLongitude);
          when(() => mockGeoModel.latitude).thenReturn(tLatitude);
          when(() => mockGeoModel.name).thenReturn(tName);
          when(() => mockGeoCollectionModel.results).thenReturn(mockGeoModels);
          when(() => remoteDataSource.getGeoByKeyword(tName))
              .thenAnswer((_) async => mockGeoCollectionModel);
          // act
          await repository.getForecastByName(tName);
          // assert
          verify(() =>
                  remoteDataSource.getForecastByLongLat(tLongitude, tLatitude))
              .called(1);
        });

        test('return server failure when getForecastByLongLat throws',
            () async {
          // arrange
          final mockGeoCollectionModel = MockGeoCollectionModel();
          final mockGeoModel = MockGeoModel();
          final mockGeoModels = [mockGeoModel];
          when(() => mockGeoModel.longitude).thenReturn(tLongitude);
          when(() => mockGeoModel.latitude).thenReturn(tLatitude);
          when(() => mockGeoModel.name).thenReturn(tName);
          when(() => mockGeoCollectionModel.results).thenReturn(mockGeoModels);
          when(() => remoteDataSource.getGeoByKeyword(tName))
              .thenAnswer((_) async => mockGeoCollectionModel);
          when(() => remoteDataSource.getForecastByLongLat(any(), any()))
              .thenThrow(Exception());
          // act
          final result = await repository.getForecastByName(tName);
          // assert
          expect(result, Left(ServerFailure()));
        });

        test(
            'cache weather data locally when the call to remote data source is successful',
            () async {
          // arrange
          final mockGeoCollectionModel = MockGeoCollectionModel();
          final mockGeoModel = MockGeoModel();
          final mockGeoModels = [mockGeoModel];
          final mockWeatherModel = MockWeatherModel();
          final mockWeatherInfoModel = MockWeatherInfoModel();
          when(() => mockWeatherInfoModel.lastUpdated).thenReturn(tLastUpdated);
          when(() => mockWeatherInfoModel.weatherCode).thenReturn(tWeatherCode);
          when(() => mockWeatherModel.currentWeather)
              .thenReturn(mockWeatherInfoModel);
          when(() => mockGeoModel.longitude).thenReturn(tLongitude);
          when(() => mockGeoModel.latitude).thenReturn(tLatitude);
          when(() => mockGeoModel.name).thenReturn(tName);
          when(() => mockGeoCollectionModel.results).thenReturn(mockGeoModels);
          when(() => remoteDataSource.getGeoByKeyword(tName))
              .thenAnswer((_) async => mockGeoCollectionModel);
          when(() =>
                  remoteDataSource.getForecastByLongLat(tLongitude, tLatitude))
              .thenAnswer((_) async => mockWeatherModel);
          try {
            // act
            await repository.getForecastByName(tName);
          } catch (_) {}
          // assert
          verify(() => localDataSource.cacheWeather(mockWeatherModel))
              .called(1);
        });

        test(
            'cache name data locally when the call to remote data source is successful',
            () async {
          // arrange
          final mockGeoCollectionModel = MockGeoCollectionModel();
          final mockGeoModel = MockGeoModel();
          final mockGeoModels = [mockGeoModel];
          final mockWeatherModel = MockWeatherModel();
          final mockWeatherInfoModel = MockWeatherInfoModel();
          when(() => mockWeatherInfoModel.lastUpdated).thenReturn(tLastUpdated);
          when(() => mockWeatherInfoModel.weatherCode).thenReturn(tWeatherCode);
          when(() => mockWeatherModel.currentWeather)
              .thenReturn(mockWeatherInfoModel);
          when(() => mockGeoModel.longitude).thenReturn(tLongitude);
          when(() => mockGeoModel.latitude).thenReturn(tLatitude);
          when(() => mockGeoModel.name).thenReturn(tName);
          when(() => mockGeoCollectionModel.results).thenReturn(mockGeoModels);
          when(() => remoteDataSource.getGeoByKeyword(tName))
              .thenAnswer((_) async => mockGeoCollectionModel);
          when(() =>
                  remoteDataSource.getForecastByLongLat(tLongitude, tLatitude))
              .thenAnswer((_) async => mockWeatherModel);
          when(() => localDataSource.cacheWeather(mockWeatherModel))
              .thenAnswer((_) async => {});
          try {
            // act
            await repository.getForecastByName(tName);
          } catch (_) {}
          // assert
          verify(() => localDataSource.cacheName(tName)).called(1);
        });

        test('return correct model with all correct datas', () async {
          // arrange
          final mockGeoCollectionModel = MockGeoCollectionModel();
          final mockGeoModel = MockGeoModel();
          final mockGeoModels = [mockGeoModel];
          final mockWeatherModel = MockWeatherModel();
          final mockWeatherInfoModel = MockWeatherInfoModel();
          when(() => mockWeatherInfoModel.lastUpdated).thenReturn(tLastUpdated);
          when(() => mockWeatherInfoModel.weatherCode).thenReturn(tWeatherCode);
          when(() => mockWeatherInfoModel.temperature).thenReturn(tTemperature);
          when(() => mockWeatherModel.currentWeather)
              .thenReturn(mockWeatherInfoModel);
          when(() => mockGeoModel.longitude).thenReturn(tLongitude);
          when(() => mockGeoModel.latitude).thenReturn(tLatitude);
          when(() => mockGeoModel.name).thenReturn(tName);
          when(() => mockGeoCollectionModel.results).thenReturn(mockGeoModels);
          when(() => remoteDataSource.getGeoByKeyword(tName))
              .thenAnswer((_) async => mockGeoCollectionModel);
          when(() =>
                  remoteDataSource.getForecastByLongLat(tLongitude, tLatitude))
              .thenAnswer((_) async => mockWeatherModel);
          when(() => localDataSource.cacheWeather(mockWeatherModel))
              .thenAnswer((_) async => {});
          when(() => localDataSource.cacheName(tName))
              .thenAnswer((_) async => {});
          // act
          final result = await repository.getForecastByName(tName);
          // assert
          expect(result, Right(tWeather));
          verify(() =>
                  remoteDataSource.getForecastByLongLat(tLongitude, tLatitude))
              .called(1);
        });
      });

      group('device is offline', () {
        setUp(() {
          when(() => networkInfo.isConnected).thenAnswer((_) async => false);
        });

        test('return last locally cached data when the cached data is present',
            () async {
          // arrange
          final mockWeatherModel = MockWeatherModel();
          final mockWeatherInfoModel = MockWeatherInfoModel();
          when(() => mockWeatherInfoModel.lastUpdated).thenReturn(tLastUpdated);
          when(() => mockWeatherInfoModel.weatherCode).thenReturn(tWeatherCode);
          when(() => mockWeatherInfoModel.temperature).thenReturn(tTemperature);
          when(() => mockWeatherModel.currentWeather)
              .thenReturn(mockWeatherInfoModel);
          when(() => localDataSource.getLastWeather())
              .thenAnswer((_) async => mockWeatherModel);
          when(() => localDataSource.getLastName())
              .thenAnswer((_) async => tName);
          // act
          final result = await repository.getForecastByName(tName);
          // assert
          expect(result, Right(tWeather));
          verify(() => localDataSource.getLastWeather()).called(1);
          verify(() => localDataSource.getLastName()).called(1);
        });

        test(
            'return CacheFailure on getName when there is no cached data present',
            () async {
          // arrange
          final mockWeatherModel = MockWeatherModel();
          final mockWeatherInfoModel = MockWeatherInfoModel();
          when(() => mockWeatherInfoModel.lastUpdated).thenThrow(tLastUpdated);
          when(() => mockWeatherInfoModel.weatherCode).thenReturn(tWeatherCode);
          when(() => mockWeatherInfoModel.temperature).thenReturn(tTemperature);
          when(() => mockWeatherModel.currentWeather)
              .thenReturn(mockWeatherInfoModel);
          when(() => localDataSource.getLastWeather())
              .thenAnswer((_) async => mockWeatherModel);
          when(() => localDataSource.getLastName()).thenThrow(CacheException());
          // act
          final result = await repository.getForecastByName(tName);
          // assert
          expect(result, Left(CacheFailure()));
          verify(() => localDataSource.getLastName()).called(1);
        });

        test(
            'return CacheFailure on getLastWeather when there is no cached data present',
            () async {
          // arrange
          final mockWeatherModel = MockWeatherModel();
          final mockWeatherInfoModel = MockWeatherInfoModel();
          when(() => mockWeatherInfoModel.lastUpdated).thenThrow(tLastUpdated);
          when(() => mockWeatherInfoModel.weatherCode).thenReturn(tWeatherCode);
          when(() => mockWeatherInfoModel.temperature).thenReturn(tTemperature);
          when(() => mockWeatherModel.currentWeather)
              .thenReturn(mockWeatherInfoModel);
          when(() => localDataSource.getLastWeather())
              .thenThrow(CacheException());
          when(() => localDataSource.getLastName())
              .thenAnswer((_) async => tName);
          // act
          final result = await repository.getForecastByName(tName);
          // assert
          expect(result, Left(CacheFailure()));
          verify(() => localDataSource.getLastWeather()).called(1);
        });
      });
    });
  });
}
