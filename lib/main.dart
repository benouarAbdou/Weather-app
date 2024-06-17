import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/bloc/weather_bloc_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: _determinePosition(),
            builder: (context, snap) {
              if (snap.hasData) {
                return BlocProvider<WeatherBlocBloc>(
                  create: (context) => WeatherBlocBloc()
                    ..add(FetchWeather(snap.data as Position)),
                  child: const MyHomePage(),
                );
              } else {
                return const Scaffold(
                  body: Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballRotateChase,

                        /// Required, The loading type of the widget
                        colors: [
                          Colors.blueAccent,
                        ],

                        /// Optional, the stroke backgroundColor
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (serviceEnabled == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget getWeatherIcon(int code, int source, [DateTime? time]) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset('assets/1.png');
      case >= 300 && < 400:
        return Image.asset('assets/2.png');
      case >= 500 && < 600:
        return Image.asset('assets/3.png');
      case >= 600 && < 700:
        return Image.asset('assets/4.png');
      case >= 700 && < 800:
        return Image.asset('assets/5.png');
      case == 800:
        if ((!isMorning() && source == 0) ||
            (time != null && (time.hour > 20 || time.hour < 4))) {
          return Image.asset('assets/12.png');
        } else {
          return Image.asset('assets/6.png');
        }
      case > 800 && <= 804:
        if ((!isMorning() && source == 0) ||
            (time != null && (time.hour > 20 || time.hour < 4))) {
          return Image.asset('assets/15.png');
        } else {
          return Image.asset('assets/7.png');
        }
      default:
        return Image.asset('assets/7.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isMorning() ? Colors.white : Colors.black,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            Align(
              alignment: const AlignmentDirectional(10, 0),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isMorning()
                      ? const Color.fromARGB(255, 105, 178, 238)
                      : Colors.deepPurple,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(-10, 0),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isMorning()
                      ? const Color.fromARGB(255, 105, 178, 238)
                      : Colors.deepPurple,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, -1.2),
              child: Container(
                height: 300,
                width: 600,
                decoration: BoxDecoration(
                    color: isMorning()
                        ? const Color.fromARGB(255, 255, 195, 106)
                        : Colors.orange),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 100.0,
                sigmaY: 100.0,
              ),
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
              ),
            ),
            BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
              builder: (context, state) {
                if (state is WeatherBlocSuccess) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: kToolbarHeight,
                        ),
                        Text(
                          '📍 ${state.weather.areaName}',
                          style: TextStyle(
                              color: isMorning() ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isMorning() ? 'Good Morning' : 'Good Evening',
                          style: TextStyle(
                              color: isMorning() ? Colors.black : Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Center(
                          child: SizedBox(
                              height: 300,
                              width: 300,
                              child: getWeatherIcon(
                                  state.weather.weatherConditionCode!, 0)),
                        ),
                        Center(
                          child: Text(
                            '${state.weather.temperature!.celsius!.round()}°C',
                            style: TextStyle(
                                color:
                                    isMorning() ? Colors.black : Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Center(
                          child: Text(
                            state.weather.weatherMain!.toUpperCase(),
                            style: TextStyle(
                                color:
                                    isMorning() ? Colors.black : Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Text(
                            DateFormat('EEEE dd •')
                                .add_jm()
                                .format(state.weather.date!),
                            style: TextStyle(
                                color:
                                    isMorning() ? Colors.black : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/11.png',
                                  scale: 8,
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sunrise',
                                      style: TextStyle(
                                          color: isMorning()
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      DateFormat()
                                          .add_jm()
                                          .format(state.weather.sunrise!),
                                      style: TextStyle(
                                          color: isMorning()
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/12.png',
                                  scale: 8,
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sunset',
                                      style: TextStyle(
                                          color: isMorning()
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      DateFormat()
                                          .add_jm()
                                          .format(state.weather.sunset!),
                                      style: TextStyle(
                                          color: isMorning()
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Image.asset(
                                'assets/13.png',
                                scale: 8,
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Temp Max',
                                    style: TextStyle(
                                        color: isMorning()
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "${state.weather.tempMax!.celsius!.round()} °C",
                                    style: TextStyle(
                                        color: isMorning()
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              )
                            ]),
                            Row(children: [
                              Image.asset(
                                'assets/14.png',
                                scale: 8,
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Temp Min',
                                    style: TextStyle(
                                        color: isMorning()
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "${state.weather.tempMin!.celsius!.round()} °C",
                                    style: TextStyle(
                                        color: isMorning()
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              )
                            ]),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5, // Set the thickness as needed
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "5 days forecast",
                          style: TextStyle(
                            fontSize: 18,
                            color: isMorning() ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: state.forecast
                              .fold<Map<String, List<Weather>>>(
                                {},
                                (Map<String, List<Weather>> acc, dayForecast) {
                                  final dayKey = DateFormat('yyyy-MM-dd')
                                      .format(dayForecast.date!);
                                  if (!acc.containsKey(dayKey)) {
                                    acc[dayKey] = [];
                                  }
                                  acc[dayKey]!.add(dayForecast);
                                  return acc;
                                },
                              )
                              .values
                              .take(5)
                              .map<Widget>((dayForecasts) {
                                final maxTemp = dayForecasts
                                    .map((forecast) =>
                                        forecast.temperature!.celsius!)
                                    .reduce((max, current) =>
                                        current > max ? current : max);
                                final minTemp = dayForecasts
                                    .map((forecast) =>
                                        forecast.temperature!.celsius!)
                                    .reduce((min, current) =>
                                        current < min ? current : min);
                                final mostRepeatedCode = dayForecasts
                                    .map((forecast) =>
                                        forecast.weatherConditionCode)
                                    .fold<Map<int, int>>(
                                      {},
                                      (Map<int, int> acc, code) {
                                        if (!acc.containsKey(code)) {
                                          acc[code!] = 0;
                                        }
                                        acc[code!] = acc[code]! + 1;
                                        return acc;
                                      },
                                    )
                                    .entries
                                    .reduce((a, b) => a.value > b.value ? a : b)
                                    .key;
                                return Column(
                                  children: [
                                    Text(
                                      DateFormat('EEE')
                                          .format(dayForecasts.first.date!),
                                      style: TextStyle(
                                        color: isMorning()
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                      width: 25,
                                      child:
                                          getWeatherIcon(mostRepeatedCode, 1),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${maxTemp.round()}°',
                                          style: TextStyle(
                                            color: isMorning()
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${minTemp.round()}°',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isMorning()
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              })
                              .toList(),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5, // Set the thickness as needed
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Next 15 hours forecast",
                          style: TextStyle(
                            fontSize: 18,
                            color: isMorning() ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            state.forecast.length < 5
                                ? state.forecast.length
                                : 5,
                            (index) => Column(
                              children: [
                                Text(
                                  DateFormat('jm')
                                      .format(state.forecast[index].date!),
                                  style: TextStyle(
                                    color: isMorning()
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: getWeatherIcon(
                                      state.forecast[index]
                                          .weatherConditionCode!,
                                      1,
                                      state.forecast[index].date!),
                                ),
                                Text(
                                  '${state.forecast[index].temperature!.celsius!.round()}°',
                                  style: TextStyle(
                                    color: isMorning()
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5, // Set the thickness as needed
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Next 40 hours forecast",
                          style: TextStyle(
                            fontSize: 18,
                            color: isMorning() ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 250,
                          child: buildBarChart(state.forecast, context),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}

Widget buildBarChart(List<Weather> forecast, context) {
  LinearGradient barsGradient = const LinearGradient(
    colors: [Colors.greenAccent, Colors.blueAccent],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  double maxTemp = forecast
      .map((weather) => weather.temperature!.celsius!)
      .reduce((a, b) => a > b ? a : b);
  double minTemp = forecast
      .map((weather) => weather.temperature!.celsius!)
      .reduce((a, b) => a < b ? a : b);

  print(forecast);
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SizedBox(
      width: MediaQuery.of(context).size.width, // Take all available width

      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipColor: (group) => Colors.white,
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                return BarTooltipItem(
                  "${rod.toY.round()}° at ${DateFormat('jm').format(forecast[groupIndex].date!)}",
                  const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          groupsSpace: 5,
          gridData: const FlGridData(
              show: true, horizontalInterval: 4, verticalInterval: 8),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  var style = TextStyle(
                    color: isMorning() ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  );

                  int index = value.toInt();
                  if (index % 8 == 0 && index < forecast.length) {
                    return Text(
                      DateFormat('EEE').format(forecast[index].date!),
                      style: style,
                    );
                  }

                  return Container(); // Return an empty container for non-matching indices
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  var style = TextStyle(
                    color: isMorning() ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  );
                  if (value == maxTemp + 2) {
                    return Container(); // Avoid showing the max value twice
                  }
                  return Text(value.toInt().toString(), style: style);
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),

          minY: minTemp - 2,
          maxY: maxTemp + 2, // Adjust based on temperature range
          barGroups: forecast.asMap().entries.map((entry) {
            int idx = entry.key;
            Weather weather = entry.value;
            return BarChartGroupData(
              barsSpace: 50,
              x: idx,
              barRods: [
                BarChartRodData(
                  gradient: barsGradient,
                  toY: weather.temperature!.celsius!.round().toDouble(),
                  width: 8,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    ),
  );
}

bool isMorning() {
  final hour = DateTime.now().hour;
  //return hour >= 18 && hour < 24;
  return hour >= 6 && hour < 20;
}
