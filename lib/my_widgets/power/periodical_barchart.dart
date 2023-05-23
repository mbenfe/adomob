import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../m_define.dart';

int modeKwhEuros = CONSOMATION_MODE_EUROS;

class WidgetPeriodicalCharts extends StatefulWidget {
  final Map<String, double> heures;
  final Map<String, double> jours;
  final Map<String, double> mois;
  const WidgetPeriodicalCharts({
    required this.heures,
    required this.jours,
    required this.mois,
    Key? key,
  }) : super(key: key);

  @override
  State<WidgetPeriodicalCharts> createState() => _WidgetPeriodicalChartsState();
}

class _WidgetPeriodicalChartsState extends State<WidgetPeriodicalCharts> {
  @override
  Widget build(BuildContext context) {
    //   TabController tabController = TabController(length: 3, vsync: this);
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
            child: TabBar(
              tabs: [
                Tab(text: '24 Heures'),
                Tab(text: 'Semaine'),
                Tab(text: 'Année'),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: TabBarView(
              children: [
                PowerBarCharts(consomation: widget.heures),
                PowerBarCharts(consomation: widget.jours),
                PowerBarCharts(consomation: widget.mois),
              ],
            ),
          ),
          ToggleSwitch(
            inactiveBgColor: Colors.white,
            activeBgColor: const [Colors.blue, Colors.blue],
            customIcons: const [
              Icon(
                Icons.euro,
                color: Colors.black,
              ),
              Icon(
                Icons.electric_meter,
                color: Colors.black,
              )
            ],
            totalSwitches: 2,
            initialLabelIndex: modeKwhEuros,
            onToggle: (value) {
              setState(() {
                modeKwhEuros = value!;
              });
            },
          ),
        ],
      ),
    );
  }
}

class PowerBarCharts extends StatelessWidget {
  const PowerBarCharts({required this.consomation, super.key});
  final Map<String, double> consomation;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 1,
      onDataLabelRender: formatLabelCreated,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 1),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 1),
        labelFormat: modeKwhEuros == CONSOMATION_MODE_EUROS ? '{value}€' : '{value}Kwh',
        majorTickLines: const MajorTickLines(size: 1),
      ),
      series: _getDefaultColumnSeries(),
    );
  }

  List<ColumnSeries<ChartData, String>> _getDefaultColumnSeries() {
    return <ColumnSeries<ChartData, String>>[
      ColumnSeries<ChartData, String>(
        dataSource: convertConsomation(consomation),
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y,
        dataLabelSettings: const DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 10)),
      )
    ];
  }

  List<ChartData> convertConsomation(Map<String, double> consomation) {
    List<ChartData> list = [];
    if (modeKwhEuros == CONSOMATION_MODE_EUROS) {
      consomation.forEach((key, value) => list.add(ChartData(x: key, y: value * globalPrixHeuresCreuses)));
    } else {
      consomation.forEach((key, value) => list.add(ChartData(x: key, y: value)));
    }
    return list;
  }
}

class ChartData {
  ChartData({required this.x, required this.y});
  final String x;
  final double y;
}

void formatLabelCreated(DataLabelRenderArgs args) {
  String newText = "";
  double value;
  int length;

  length = args.text.length;
  if (modeKwhEuros == CONSOMATION_MODE_KWH) {
    newText = args.text.substring(0, length - 3);

    value = double.parse(newText);
    if (value < 1) {
      if (value != 0) {
        newText = value.toStringAsFixed(3);
      } else {
        newText = "";
      }
    } else {
      newText = value.toStringAsFixed(1);
    }
    args.text = newText;
  } else {
    // euros et centimes
    newText = args.text.substring(0, length - 1);
    value = double.parse(newText);
//    value *= globalPrixHeuresPleines;
    if (value < 1) {
      if (value != 0) {
        value *= 100;
        newText = value.toStringAsFixed(1);
        newText += 'c';
      } else {
        newText = "";
      }
    } else {
      newText = value.toStringAsFixed(1);
    }
    args.text = newText;
  }
}
