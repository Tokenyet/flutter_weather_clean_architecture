import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_clean_architecture/core/network/network_status.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/entities/weather.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/repositories/weather_repository.dart';
import 'package:flutter_weather_clean_architecture/features/weather/domain/usecases/get_forecast_by_name.dart';
import 'package:flutter_weather_clean_architecture/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:flutter_weather_clean_architecture/features/weather/presentation/pages/search_page.dart';
import 'package:flutter_weather_clean_architecture/features/weather/presentation/widgets/weather_empty.dart';
import 'package:flutter_weather_clean_architecture/features/weather/presentation/widgets/weather_error.dart';
import 'package:flutter_weather_clean_architecture/features/weather/presentation/widgets/weather_loading.dart';
import 'package:flutter_weather_clean_architecture/features/weather/presentation/widgets/weather_populated.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherRepo = context.read<WeatherRepository>();
    return BlocProvider(
      create: (context) => WeatherBloc(
        getForecastByName: GetForecastByName(
          weatherRepository: weatherRepo,
        ),
      ),
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatefulWidget {
  const WeatherView({Key? key}) : super(key: key);

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  late WeatherBloc _weatherBloc;
  @override
  void initState() {
    _weatherBloc = context.read<WeatherBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Weather'),
        actions: [
          IconButton(
              onPressed: () async {
                final city =
                    await Navigator.of(context).push(SearchPage.route());
                if (city != null) {
                  _weatherBloc.add(WeatherSearched(keyword: city));
                }
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: Center(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            switch (state.status) {
              case NetworkStatus.init:
                return const WeatherEmpty();
              case NetworkStatus.loading:
                return const WeatherLoading();
              case NetworkStatus.success:
                return WeatherPopulated(
                  weather: state.weather ??
                      Weather(
                        condition: WeatherCondition.clear,
                        lastUpdated: DateTime(1),
                        location: 'Unknown',
                      ),
                );
              case NetworkStatus.failure:
              default:
                return const WeatherError();
            }
          },
        ),
      ),
    );
  }
}
