import 'package:flutter/material.dart';
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

class PowerGauge extends StatefulWidget {
  const PowerGauge({
    Key? key,
    required this.jsonMap,
  }) : super(key: key);

  final Map jsonMap;

  @override
  State<PowerGauge> createState() => _PowerGaugeState();
}

class _PowerGaugeState extends State<PowerGauge> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PowerGaugeInterior(jsonMap: widget.jsonMap),
          PowerGaugeExterior(jsonMap: widget.jsonMap),
          Positioned(
              width: 50,
              height: 50,
              right: 20,
              top: 20,
              child: widget.jsonMap['ActivePower'] != null ? AnimationRipplePower(widget.jsonMap['ActivePower']!.toDouble()) : const Placeholder())
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
    return SfRadialGauge(
        //   title: const GaugeTitle(text: 'Principal', textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        enableLoadingAnimation: true,
        animationDuration: 1000,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 12000,
            showTicks: false,
            interval: 4000,
            majorTickStyle: const MinorTickStyle(color: Colors.black, length: 1),
            labelsPosition: ElementsPosition.outside,
            showLabels: false,
            //radiusFactor: 0,
            labelOffset: 20,
            axisLineStyle: const AxisLineStyle(thickness: 10, color: Colors.blue),
            pointers: <GaugePointer>[
              RangePointer(
                value: jsonMap['ActivePower'] != null ? jsonMap['ActivePower'].toDouble() : 0,
                color: Colors.red,
                width: 5,
                pointerOffset: 2,
              )
            ],
          )
        ]);
  }
}

class PowerGaugeInterior extends StatelessWidget {
  const PowerGaugeInterior({
    Key? key,
    required this.jsonMap,
  }) : super(key: key);

  final Map jsonMap;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
        // title: const GaugeTitle(text: 'Principal', textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        enableLoadingAnimation: true,
        animationDuration: 1000,
        axes: <RadialAxis>[
          RadialAxis(
              minimum: 0,
              maximum: 12000,
              axisLineStyle: const AxisLineStyle(thickness: 0),
              radiusFactor: .8,
              showLabels: false,
              labelsPosition: ElementsPosition.outside,
              majorTickStyle: const MajorTickStyle(color: Colors.black),
              interval: 2000,
              minorTicksPerInterval: 5,
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: jsonMap['ActivePower'] != null ? jsonMap['ActivePower'].toDouble() : 0,
                  enableAnimation: true,
                  needleColor: Colors.red,
                  needleLength: 0.8,
                  needleEndWidth: 1,
                  needleStartWidth: 1,
                  knobStyle: const KnobStyle(color: Colors.red),
                  tailStyle: const TailStyle(
                    width: 1,
                    length: .2,
                    color: Colors.red,
                  ),
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Text("${jsonMap['ActivePower']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  positionFactor: 0.8,
                  angle: 90,
                )
              ]),
        ]);
  }
}
