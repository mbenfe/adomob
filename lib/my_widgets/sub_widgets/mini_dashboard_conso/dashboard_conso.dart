import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../m_define.dart';
import '../../../my_models/complex_state_fz.dart';
import '../../power/periodical_barchart.dart';
import '../../state_notifier.dart';

/// ConsumerWidget for riverpod
class SubDashboardConsoWidget extends ConsumerWidget {
  const SubDashboardConsoWidget({
    Key? key,
    required this.master,
    required this.stateProvider,
  }) // required this.stateProvider})
  : super(key: key);
  final String master;
  final StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt> stateProvider;

  @override
  Widget build(BuildContext context, ref) {
    final JsonForMqtt state;
    Map<String, dynamic> teleJsonMap = {};
    state = ref.watch(stateProvider); //* power meter
    teleJsonMap = state.teleJsonMap;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Card(
            elevation: 5,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Text(teleJsonMap['ActivePower'] != null ? '${teleJsonMap['ActivePower']} Watts' : '')),
        Expanded(
          child: SubConsomationSummary(
            master: master,
            stateProvider: stateProvider,
          ),
        ),
      ],
    );
  }
}

class SubConsomationSummary extends ConsumerWidget {
  const SubConsomationSummary({Key? key, required this.master, required this.stateProvider}) : super(key: key);
  final String master;
  final StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt> stateProvider;

  @override
  Widget build(BuildContext context, ref) {
    JsonForMqtt state = JsonForMqtt(deviceId: "", teleJsonMap: {}, listOtherJsonMap: [], listCmdJsonMap: []);
    //* recoit l'etat qui contient le json telemetry et une list supplementaire de json
    //* pour l'affichages de cumuls heures, jours, mois

    //* boitier virtuel premier provider ne recoit rien, second est le maitre
    state = ref.watch(stateProvider); //* boitier virtuel premier provider ne recoit rien, second est le maitre

    //* la telemetry est traitée directment dans la widgets avec test null-safety
    Map<String, dynamic> teleJsonMap = state.teleJsonMap;

    List<Map<String, dynamic>> listJsonMap = state.listOtherJsonMap;
    final Map<String, double> jours = {};

    //* l'affichage des cumuls se fait si ils existent
    if (listJsonMap.isNotEmpty) {
      int index;
      for (index = 0; index < listJsonMap.length; index++) {
        if (listJsonMap[index]['TYPE'] == 'PWDAYS') {
          listJsonMap[index]['DATA'].forEach((key, value) => jours[key] = value.toDouble());
        }
      }
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          alignment: Alignment.topCenter,
          //        height: POWER_VERTICAL_WIDGET_SIZE,
          width: MediaQuery.of(context).size.width,
          child: myPowerBarCharts(consomation: jours),
        );
      },
      // containter frame
    );
  }
}

class myPowerBarCharts extends StatelessWidget {
  const myPowerBarCharts({required this.consomation, super.key});

  final Map<String, double> consomation;

  List<ChartData> convertConsomation(Map<String, double> consomation) {
    const List<String> weekDay = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
    var day = DateTime.now().weekday;
    var pastDay = 0;
    if (day > 0) {
      pastDay = day - 1;
    } else {
      pastDay = 6;
    }

    List<ChartData> list = [];
    if (consomation[weekDay[pastDay]] != null) {
      list.add(ChartData(x: 'hier', y: consomation[weekDay[pastDay]]! * globalPrixHeuresCreuses));
    }
    if (consomation[weekDay[day]] != null) {
      list.add(ChartData(x: "aujourd'hui", y: consomation[weekDay[day]]! * globalPrixHeuresCreuses));
    }
    return list;
  }

  List<BarSeries<ChartData, String>> _getDefaultColumnSeries() {
    return <BarSeries<ChartData, String>>[
      BarSeries<ChartData, String>(
        dataSource: convertConsomation(consomation),
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y,
        dataLabelSettings: const DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 10)),
      )
    ];
  }

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
        labelFormat: '{value}€',
        majorTickLines: const MajorTickLines(size: 1),
      ),
      series: _getDefaultColumnSeries(),
    );
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
