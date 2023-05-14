import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _PowerBarCharts extends StatefulWidget {
  final Map<String, int> consomation;
  const _PowerBarCharts(this.consomation, {Key? key}) : super(key: key);

  @override
  State<_PowerBarCharts> createState() => MyPowerBarChartsState();
}

class MyPowerBarChartsState extends State<_PowerBarCharts> {
  @override
  Widget build(BuildContext context) {
    double getMax() {
      int index;
      double max = 0;
      for (index = 0; index < widget.consomation.length; index++) {
        if (widget.consomation[widget.consomation.keys.elementAt(index)]! > max) {
          max = widget.consomation[widget.consomation.keys.elementAt(index)]!.toDouble();
        }
      }
      return max + 8;
    }

    return BarChart(
      BarChartData(
        barTouchData: getBarTouchData,
        titlesData: getTitlesData,
        borderData: getBorderData,
        barGroups: getBarGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: getMax(),
      ),
    );
  }

  BarTouchData get getBarTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 0, // marge par rapport a la bar
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    text = widget.consomation.keys.elementAt(value.toInt());
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get getTitlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get getBorderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.blue,
          Colors.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get getBarGroups {
    List<BarChartGroupData> list = [];
    int i;
    for (i = 0; i < widget.consomation.length; i++) {
      list.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: widget.consomation[widget.consomation.keys.elementAt(i)]!.toDouble(), // if not null
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ));
    }
    return list;
  }
}

class PowerBarCharts extends StatefulWidget {
  final Map<String, int> consomation;
  const PowerBarCharts(this.consomation, {Key? key}) : super(key: key);
//  const PowerBarCharts({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PowerBarChartsState();
}

class PowerBarChartsState extends State<PowerBarCharts> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: _PowerBarCharts(widget.consomation),
    );
  }
}
