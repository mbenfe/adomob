import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_animations/my_animations.dart';
import 'package:my_models/complex_state_fz.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../state_notifier.dart';
import './power_barchart.dart';

/// ConsumerWidget for riverpod
class RootCourantWidget extends ConsumerWidget {
  const RootCourantWidget({Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
      : super(key: key);
  final String master;
  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;

  @override
  Widget build(BuildContext context, ref) {
    //* recoit l'etat qui contient le json telemetry et une list supplementaire de json
    //* pour l'affichages de cumuls heures, jours, mois
    JsonForMqtt state = ref.watch(listStateProviders[0]);

    //* la telemetry est traitée directment dans la widgets avec test null-safety
    Map<String, dynamic> teleJsonMap = state.teleJsonMap;

    List<Map<dynamic, dynamic>> listJsonMap = state.listOtherJsonMap;
    final Map<String, int> heures = {};
    final Map<String, int> jours = {};
    final Map<String, int> mois = {};

    //* l'affichage des cumuls se fait si ils existent
    if (listJsonMap.isNotEmpty) {
      int index;
      for (index = 0; index < listJsonMap.length; index++) {
        if (listJsonMap[index]['TYPE'] == 'PWHOURS') {
          listJsonMap[index]['DATA'].forEach((key, value) => heures[key] = value?.toInt());
        }
        if (listJsonMap[index]['TYPE'] == 'PWDAYS') {
          listJsonMap[index]['DATA'].forEach((key, value) => jours[key] = value?.toInt());
        }
        if (listJsonMap[index]['TYPE'] == 'PWMONTHS') {
          listJsonMap[index]['DATA'].forEach((key, value) => mois[key] = value?.toInt());
        }
      }
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          alignment: Alignment.topCenter,
          //        height: POWER_VERTICAL_WIDGET_SIZE,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFF0707), width: 2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              )),
          child: Column(
            children: [
              Text(
                location,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              PowerGauge(jsonMap: teleJsonMap),
              TempCharts(heures: heures, jours: jours, mois: mois)
            ],
          ),
        );
      },
      // containter frame
    );
  }
}

class TempCharts extends StatelessWidget {
  final Map<String, int> heures;
  final Map<String, int> jours;
  final Map<String, int> mois;
  const TempCharts({
    required this.heures,
    required this.jours,
    required this.mois,
    Key? key,
  }) : super(key: key);

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
                Tab(text: 'Heures'),
                Tab(text: 'Jours'),
                Tab(text: 'Mois'),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: TabBarView(
              children: [
                PowerBarCharts(heures),
                PowerBarCharts(jours),
                PowerBarCharts(mois),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PowerGauge extends StatelessWidget {
  const PowerGauge({
    Key? key,
    required this.jsonMap,
  }) : super(key: key);

  final Map jsonMap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          //  PowerGaugeInterior(jsonMap: jsonMap),
          PowerGaugeExterior(jsonMap: jsonMap),
          Positioned(
              width: 50,
              height: 50,
              right: 20,
              top: 20,
              child: jsonMap['ActivePower'] != null ? AnimationRipplePower(jsonMap['ActivePower']!.toDouble()) : const Placeholder())
        ],
      ),
    );
  }
}

/// external ring of the gauge
class PowerGaugeExterior extends StatelessWidget {
  const PowerGaugeExterior({
    Key? key,
    required this.jsonMap,
  }) : super(key: key);

  final Map jsonMap;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      SfRadialGauge(
          //   title: const GaugeTitle(text: 'Principal', textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          enableLoadingAnimation: true,
          animationDuration: 1000,
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 12000,
              showTicks: true,
              tickOffset: -11,
              backgroundImage: const AssetImage("images/dark_theme_gauge_wip.png"),
              interval: 2000,
              onLabelCreated: axisLabelCreated,
              labelsPosition: ElementsPosition.outside,
              showLabels: true,
              showFirstLabel: true,
              showLastLabel: true,
              canRotateLabels: true,
              radiusFactor: .93,
              labelOffset: 15,
              axisLineStyle: const AxisLineStyle(thickness: 15, color: Colors.blue),
              pointers: <GaugePointer>[
                RangePointer(
                  value: jsonMap['ActivePower'] != null ? jsonMap['ActivePower'].toDouble() : 0,
                  color: Colors.red,
                  width: 11,
                  pointerOffset: 2,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  positionFactor: 0.1,
                  widget: jsonMap['ActivePower'] != null
                      ? Text(
                          textAlign: TextAlign.center,
                          "${jsonMap['ActivePower']}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                        )
                      : const Text(''),
                ),
              ],
            ),
          ]),
      CircularText(
        radius: 58,
        position: CircularTextPosition.inside,
        children: [
          TextItem(
              text: const Text(
                'WATTS',
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
              startAngle: 110,
              direction: CircularTextDirection.anticlockwise),
        ],
      ),
    ]);
  }
}

void axisLabelCreated(AxisLabelCreatedArgs args) {
  String newText = "";
  int length;
  if (args.text != '0') {
    length = args.text.length;
    newText = args.text.substring(0, length - 3);
    newText += 'k';
    args.text = newText;
  }
}
