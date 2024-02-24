import 'package:expense_tracker_self/bar%20graph/individual_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// import 'package:expense_tracker_self/database/expense_database.dart';

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

  //calculate max for upper limit of graph
  double calculateMax() {
    double max = 500;
    //get the month with the highest amount
    widget.monthlySummary.sort();
    max = widget.monthlySummary.last * 1.05;
    if (max < 500) {
      return 500;
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    initializeBarData();
    //bar dimensions
    double barWidth = 20;
    double spaceBtwBars = 15;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SizedBox(
          width:
              barWidth * barData.length + spaceBtwBars * (barData.length - 1),
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: calculateMax(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(
                show: true,
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getBottomTitles,
                    reservedSize: 40,
                  ),
                ),
              ),
              barGroups: barData
                  .map(
                    (data) => BarChartGroupData(
                      x: data.x,
                      barRods: [
                        BarChartRodData(
                          toY: data.y,
                          width: barWidth,
                          borderRadius: BorderRadius.circular(4),
                          color: const Color(0xafa080808),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: calculateMax(),
                            color: const Color(0x9afdadada),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
              alignment: BarChartAlignment.center,
              groupsSpace: spaceBtwBars,
            ),
          ),
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const textstyle = TextStyle(
    color: Color.fromARGB(255, 6, 4, 4),
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text;
  switch (value.toInt() % 12) {
    case 0:
      text = 'J';
      break;
    case 1:
      text = 'F';
      break;
    case 2:
      text = 'M';
      break;
    case 3:
      text = 'A';
      break;
    case 4:
      text = 'M';
      break;
    case 5:
      text = 'J';
      break;
    case 6:
      text = 'J';
      break;
    case 7:
      text = 'A';
      break;
    case 8:
      text = 'S';
      break;
    case 9:
      text = 'O';
      break;
    case 10:
      text = 'N';
      break;
    case 11:
      text = 'D';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(
      text,
      style: textstyle,
    ),
  );
}
