import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

Widget buildLineChart(List<Weather> forecast, context) {
  double maxTemp = forecast
      .map((weather) => weather.temperature!.celsius!)
      .reduce((a, b) => a > b ? a : b);
  double minTemp = forecast
      .map((weather) => weather.temperature!.celsius!)
      .reduce((a, b) => a < b ? a : b);

  print(forecast);
  LinearGradient barsGradient = LinearGradient(
    colors: [
      const Color.fromARGB(255, 62, 184, 240).withOpacity(0.3),
      Colors.blueAccent.withOpacity(1)
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  DateTime? previousDate;
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SizedBox(
      width: MediaQuery.of(context).size.width, // Take all available width

      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipColor: (group) => Colors.white,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  final DateTime date = forecast[touchedSpot.spotIndex].date!;
                  return LineTooltipItem(
                    "${touchedSpot.y.round()}° at ${DateFormat('jm').format(date)}",
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          gridData: const FlGridData(
              show: true, horizontalInterval: 4, verticalInterval: 3),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                interval: 1,
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  var style = TextStyle(
                    color: isMorning() ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  );

                  int index = value.toInt();
                  DateTime currentDate = forecast[index].date!;

                  if (index < forecast.length) {
                    if (previousDate == null ||
                        previousDate!.day != currentDate.day) {
                      previousDate = currentDate;
                      return Text(
                        DateFormat('EEE').format(currentDate),
                        style: style,
                      );
                    }
                  }
                  // Show the day name only at the start of a new day

                  return Container();

                  // Return an empty container for non-matching indices
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
          lineBarsData: [
            LineChartBarData(
              color: Colors.blue,
              spots: forecast.asMap().entries.map((entry) {
                int idx = entry.key;
                Weather weather = entry.value;
                return FlSpot(
                  idx.toDouble(),
                  weather.temperature!.celsius!.round().toDouble(),
                );
              }).toList(),
              isCurved: true,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                gradient: barsGradient,
              ),
              dotData: const FlDotData(
                show: true,
              ),
            ),
          ],
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
