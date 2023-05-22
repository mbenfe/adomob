import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_models/complex_state_fz.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
    state = ref.watch(stateProvider); //* capteur temperature & humidité
    teleJsonMap = state.teleJsonMap;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: SfRadialGauge(axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: 40, ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 17, color: Colors.blue, startWidth: 10, endWidth: 10),
              GaugeRange(startValue: 17, endValue: 30, color: Colors.green, startWidth: 10, endWidth: 10),
              GaugeRange(startValue: 30, endValue: 40, color: Colors.red, startWidth: 10, endWidth: 10)
            ], pointers: <GaugePointer>[
              NeedlePointer(
                needleStartWidth: 1,
                needleEndWidth: 2,
                value: teleJsonMap['Temperature'] != null ? teleJsonMap['Temperature'].toDouble() : 0,
                enableDragging: false,
              ),
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text(
                    teleJsonMap['Temperature'] != null ? teleJsonMap['Temperature'].toStringAsFixed(0) + '°C' : '',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  angle: 90,
                  positionFactor: .8),
            ])
          ]),
        ),
      ],
    );
  }
}
