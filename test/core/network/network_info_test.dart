import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_clean_architecture/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late InternetConnectionChecker internetConnectionChecker;

  setUp(() {
    internetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl =
        NetworkInfoImpl(internetConnectionChecker: internetConnectionChecker);
  });
  group('NetworkInfo', () {
    group('isConnected', () {
      test('foward the call to InternetConnectionChecker,hasConnection',
          () async {
        // arrange
        final tHasConnectionFuture = Future.value(true);
        when(() => internetConnectionChecker.hasConnection)
            .thenAnswer((_) => tHasConnectionFuture);
        // act
        final result = networkInfoImpl.isConnected;
        // assert
        verify(() => internetConnectionChecker.hasConnection).called(1);
        expect(result, tHasConnectionFuture);
      });
    });
  });
}
