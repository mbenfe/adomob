import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SetupHeuresCreusesPleines extends StatefulWidget {
  const SetupHeuresCreusesPleines({super.key});

  @override
  State<SetupHeuresCreusesPleines> createState() => _SetupHeuresCreusesPleinesState();
}

class _SetupHeuresCreusesPleinesState extends State<SetupHeuresCreusesPleines> {
  double heureDebut = 23;
  double heureFin = 7;
  @override
  Widget build(BuildContext context) {
    return _getRadialRangeSlider();
  }

  /// Returns the radial range slider gauge
  Widget _getRadialRangeSlider() {
    return SizedBox(
      height: 200,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            axisLineStyle: const AxisLineStyle(thickness: 1),
            canRotateLabels: true,
            minimum: 0,
            maximum: 24,
            labelsPosition: ElementsPosition.outside,
            interval: 1,
            minorTicksPerInterval: 0,
            startAngle: 270,
            endAngle: 270,
            pointers: <GaugePointer>[
              //First thumb
              MarkerPointer(
                value: heureDebut,
                enableDragging: true,
                color: Colors.green.shade900,
                markerHeight: 15,
                markerWidth: 15,
                markerOffset: 2,
                markerType: MarkerType.circle,
                onValueChanged: (double value) {
                  setState(() {
                    heureDebut = value.roundToDouble();
                  });
                },
                //    onValueChanging: heureSoirChanging,
              ),

              //Second thumb
              MarkerPointer(
                value: heureFin,
                enableDragging: true,
                color: Colors.green.shade900,
                markerHeight: 15,
                markerWidth: 15,
                markerOffset: 2,
                markerType: MarkerType.circle,
                onValueChanged: (double value) {
                  setState(() {
                    heureFin = value.roundToDouble();
                  });
                },
                //          onValueChanging: heureMatinChanging,
              ),
            ],

            //Add the track color between thumbs
            ranges: <GaugeRange>[
              GaugeRange(
                  color: Colors.green.shade900,
                  endValue: heureFin,
                  sizeUnit: GaugeSizeUnit.factor,
                  startValue: heureDebut,
                  startWidth: 0.06,
                  endWidth: 0.06),
              GaugeRange(
                  color: Colors.green, endValue: heureDebut, sizeUnit: GaugeSizeUnit.factor, startValue: heureFin, startWidth: 0.03, endWidth: 0.03),
            ],
          )
        ],
      ),
    );
  }
}
