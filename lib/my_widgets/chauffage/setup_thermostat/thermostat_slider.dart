import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../my_notifiers/thermostat_selected_period_manager.dart';

List<String> labels = ['SEMAINE', 'WEEKEND', 'ABSENCE'];

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
              inactiveTrackColor: Theme.of(context).primaryColor,
              activeTrackColor: Theme.of(context).primaryColor,
              activeTrackHeight: 2,
              inactiveTrackHeight: 2,
            ),
            child: SfSlider(
              min: 0,
              max: 2,
              edgeLabelPlacement: EdgeLabelPlacement.inside,
              stepSize: 1,
              showLabels: true,
              value: _value,
              labelFormatterCallback: (dynamic actualValue, String formattedText) {
                switch (actualValue) {
                  case 0:
                    return 'SEMAINE';
                  case 1:
                    return 'WEEKEND';
                  case 2:
                    return 'ABSENCE';
                }
                return actualValue.toString();
              },
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
