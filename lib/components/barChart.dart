import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

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
  DateTime? previousDate;

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
