import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../my_animations/my_animations.dart';

class WidgetGauge extends StatelessWidget {
  const WidgetGauge({
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
            child: jsonMap['ActivePower'] != null
                ? AnimationRipplePower(
                    jsonMap['ActivePower']!.toDouble(),
                  )
                : const Placeholder(),
          ),
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
              onLabelCreated: formatLabelCreated,
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

void formatLabelCreated(AxisLabelCreatedArgs args) {
  String newText = "";
  int length;
  if (args.text != '0') {
    length = args.text.length;
    newText = args.text.substring(0, length - 3);
    newText += 'k';
    args.text = newText;
  }
}
