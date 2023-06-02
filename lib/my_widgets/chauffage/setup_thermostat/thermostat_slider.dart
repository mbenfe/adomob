import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../my_notifiers/thermostat_selected_period_manager.dart';

List<String> labels = ['SEMAINE', 'WEEKEND', 'ABSENCE'];

List<IconData> sliderIcons = [MdiIcons.alphaS, MdiIcons.alphaW, Icons.luggage_rounded];

final List<Color> tabColors = [Colors.blue, Colors.purple, Colors.amber];

//String selectedPeriode = 'SEMAINE';

double _value = 0;

class ModalPeriodeSelectionSlider extends ConsumerStatefulWidget {
  const ModalPeriodeSelectionSlider({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PeriodSelectionSliderState();
}

class _PeriodSelectionSliderState extends ConsumerState<ModalPeriodeSelectionSlider> {
  @override
  Widget build(BuildContext context) {
//    ref.watch(selectedPeriodProvider);
    return Card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: SfSliderTheme(
            data: SfSliderThemeData(
              inactiveTrackColor: tabColors[_value.toInt()],
              activeTrackColor: tabColors[_value.toInt()],
              activeTrackHeight: 1,
              inactiveTrackHeight: 1,
              inactiveTickColor: tabColors[_value.toInt()],
              activeTickColor: tabColors[_value.toInt()],
              tickOffset: const Offset(0, -5),
              thumbRadius: 20,
              thumbStrokeWidth: 2,
              thumbColor: Colors.white,
              thumbStrokeColor: tabColors[_value.toInt()],
            ),
            child: SfSlider(
              min: 0,
              max: 2,
              edgeLabelPlacement: EdgeLabelPlacement.inside,
              stepSize: 1,
              showLabels: false,
              showTicks: true,
              value: _value,
              thumbIcon: Icon(sliderIcons[_value.toInt()], color: tabColors[_value.toInt()]),
              interval: 1,
              onChanged: (dynamic value) {
                setState(() {
                  _value = value;
//                  periodeNotifier = labels[value.toInt()];
                  selectedPeriode = labels[value.toInt()];
                  ref.read(selectedPeriodProvider.notifier).state = labels[value.toInt()];
                });
                //              periodeNotifier.state = Periode(selectedPeriode);
              },
            ),
          ),
        ),
      ),
    );
  }
}

String formatLabels(dynamic value, String formatted) {
  switch (value) {
    case 0:
      return 'SEMAINE';
    case 1:
      return 'WEEKEND';
    case 2:
      return 'ABSENCE';
  }
  return value.toString();
}
