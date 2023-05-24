import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../my_models/complex_state_fz.dart';
import '../../state_notifier.dart';

/// ConsumerWidget for riverpod
class SubGaugeExterieureWidget extends ConsumerWidget {
  const SubGaugeExterieureWidget({
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
    state = ref.watch(stateProvider); //* capteur temperature & humidité
    teleJsonMap = state.teleJsonMap;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          //********************** TEMPERATURE *******************/
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SfRadialGauge(axes: <RadialAxis>[
              RadialAxis(
                  ranges: <GaugeRange>[
                    GaugeRange(startValue: 0, endValue: 17, color: Colors.blue, startWidth: 10, endWidth: 10),
                    GaugeRange(startValue: 17, endValue: 30, color: Colors.green, startWidth: 10, endWidth: 10),
                    GaugeRange(startValue: 30, endValue: 40, color: Colors.red, startWidth: 10, endWidth: 10),
                  ],
                  radiusFactor: 1,
                  interval: 5,
                  showLabels: false,
                  showTicks: false,
                  backgroundImage: const AssetImage("images/temperature_gauge.png"),
                  minimum: 0,
                  maximum: 40,
                  axisLineStyle: const AxisLineStyle(thickness: 10),
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      needleStartWidth: 1,
                      needleEndWidth: 2,
                      needleColor: Colors.green,
                      knobStyle: const KnobStyle(color: Colors.green),
                      lengthUnit: GaugeSizeUnit.factor,
                      needleLength: .67,
                      tailStyle: const TailStyle(width: 3, lengthUnit: GaugeSizeUnit.factor, length: .2, color: Colors.green),
                      value: teleJsonMap['Temperature'] != null ? teleJsonMap['Temperature'].toDouble() : 0,
                      enableDragging: false,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text(
                          teleJsonMap['Temperature'] != null ? teleJsonMap['Temperature'].toStringAsFixed(2) + '°C' : '',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        angle: 90,
                        positionFactor: .8),
                  ]),
              RadialAxis(
                interval: 5,
                minimum: 0,
                maximum: 40,
                showAxisLine: false,
                offsetUnit: GaugeSizeUnit.factor,
                majorTickStyle: const MajorTickStyle(color: Colors.black54, length: 10),
                minorTickStyle: const MinorTickStyle(color: Colors.black26),
                showFirstLabel: true,
                showLastLabel: true,
                showLabels: true,
                canRotateLabels: false,
                labelsPosition: ElementsPosition.inside,
                labelOffset: 0,
                axisLabelStyle: const GaugeTextStyle(color: Colors.black),
                radiusFactor: 1,
                tickOffset: 0,
              )
            ]),
          ),
        ),
        Flexible(
          //********************** HUMIDITY *******************/
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SfRadialGauge(axes: <RadialAxis>[
              RadialAxis(
                  backgroundImage: const AssetImage("images/humidity_gauge.png"),
                  ranges: <GaugeRange>[
                    GaugeRange(startValue: 40, endValue: 50, color: Colors.yellow, startWidth: 10, endWidth: 10),
                    GaugeRange(startValue: 50, endValue: 70, color: Colors.green, startWidth: 10, endWidth: 10),
                    GaugeRange(startValue: 70, endValue: 85, color: Colors.orange, startWidth: 10, endWidth: 10),
                    GaugeRange(startValue: 85, endValue: 100, color: Colors.red, startWidth: 10, endWidth: 10)
                  ],
                  minimum: 40,
                  maximum: 100,
                  startAngle: 130,
                  showTicks: false,
                  endAngle: 50,
                  radiusFactor: 1,
                  showLabels: false,
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      needleLength: .5,
                      needleColor: Colors.red,
                      knobStyle: const KnobStyle(color: Colors.red),
                      tailStyle: const TailStyle(width: 3, lengthUnit: GaugeSizeUnit.factor, length: .2, color: Colors.red),
                      needleStartWidth: 1,
                      needleEndWidth: 2,
                      value: teleJsonMap['Humidity'] != null ? teleJsonMap['Humidity'].toDouble() : 0,
                    )
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text(
                          teleJsonMap['Humidity'] != null ? teleJsonMap['Humidity'].toStringAsFixed(0) + '%' : '',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        angle: 90,
                        positionFactor: .8),
                  ]),
              RadialAxis(
                interval: 10,
                minimum: 40,
                maximum: 100,
                showAxisLine: false,
                offsetUnit: GaugeSizeUnit.factor,
                majorTickStyle: const MajorTickStyle(color: Colors.black54, length: 10),
                minorTickStyle: const MinorTickStyle(color: Colors.black26),
                showFirstLabel: true,
                showLastLabel: true,
                showLabels: true,
                labelsPosition: ElementsPosition.inside,
                labelOffset: 0,
                axisLabelStyle: const GaugeTextStyle(color: Colors.white),
                radiusFactor: 1,
                tickOffset: 0,
              )
            ]),
          ),
        ),
      ],
    );
  }
}

Widget build(BuildContext context) {
  return Scaffold(
    body: SfGaugeTheme(data: SfGaugeThemeData(brightness: Brightness.dark, backgroundColor: Colors.grey), child: SfRadialGauge()),
  );
}
