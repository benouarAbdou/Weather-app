part of 'weather_bloc_bloc.dart';

abstract class WeatherBlocEvent extends Equatable {
  const WeatherBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherBlocEvent {
  final Position position;

  const FetchWeather(this.position);

  @override
  List<Object> get props => [position];
}

class FetchForecast extends WeatherBlocEvent {
  final Position position;

  const FetchForecast(this.position);

  @override
  List<Object> get props => [position];
}
