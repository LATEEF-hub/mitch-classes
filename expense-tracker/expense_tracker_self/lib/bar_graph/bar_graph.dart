import 'package:expense_tracker_self/bar_graph/individual_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatefulWidget {
  final List<double> monthlySummary;
  final int startMonth;
  const MyBarGraph({
    super.key,
    required this.monthlySummary,
    required this.startMonth,
  });

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  //thus list will hold the data for each bar
  List<IndividualBar> barData = [];

  //initialize bar data-user our monthly summary to create a list of Bars
  void initializeBarData() {
    barData = List.generate(
      widget.monthlySummary.length,
      (index) => IndividualBar(
        x: index,
        y: widget.monthlySummary[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 100,
        // gridData: const FlGridData(show: false),
        // borderData: FlBorderData(show: false),
        // titlesData: const FlTitlesData(
        //   show: true,
        //   topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        //   leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        //   rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        //   bottomTitles: AxisTitles(
        //     sideTitles: SideTitles(
        //       showTitles: true,
        //       // getTitlesWidget: getBottomTitles,
        //     ),
        //   ),
        // ),
      ),
    );
  }

  // Widget getBottomTitles (double value, TitleMeta meta) {
  //   const
  // }
}
