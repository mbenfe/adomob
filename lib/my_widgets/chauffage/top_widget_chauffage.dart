import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../m_build_from_json.dart';
import '../../my_models/complex_state_fz.dart';
import '../../my_notifiers/thermostat_selected_period_manager.dart';
import '../../my_notifiers/widgets_manager.dart';
import '../sub_widgets/thermostat/thermostat.dart';

List<String> labels = ['MANUEL', 'AUTO', 'ABSENCE'];

double _value = 1;

final setupLaunchProvider = StateProvider<bool>((ref) {
  return false;
});

class TopWidgetChauffage extends ConsumerStatefulWidget {
  const TopWidgetChauffage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopWidgetChauffageState();
}

class _TopWidgetChauffageState extends ConsumerState<TopWidgetChauffage> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Flexible(
        flex: 4,
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
                    return 'MANUEL';
                  case 1:
                    return 'AUTO';
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
      Flexible(
        flex: 1,
        child: IconButton(
          onPressed: () {
            setState(() {
              ref.read(setupLaunchProvider.notifier).state = true;
              List<String> listSlaves = [];
              List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listProviders = [];
              extractListSlaves(listSlaves, listProviders);
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return RootThermostatWidget(listSlaves: listSlaves, listStateProviders: listProviders);
                },
              );
            });
          },
          icon: const Icon(Icons.settings),
        ),
      ),
    ]));
  }
}

String formatLabels(dynamic value, String formatted) {
  switch (value) {
    case 0:
      return 'MANUEL';
    case 1:
      return 'AUTO';
    case 2:
      return 'ABSENCE';
  }
  return value.toString();
}

class LaunchSetup extends ConsumerStatefulWidget {
  const LaunchSetup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LaunchSetupState();
}

class _LaunchSetupState extends ConsumerState<LaunchSetup> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void extractListSlaves(List<String> listSlaves, List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders) {
  //* selection des esclaves chauffage
  List<Bundle> listExtractedAppBundles = listBundles.where((element) => element.type == 'Chauffage').toList();
  // construction des list esclaves et de la liste de leurs providers
  for (int i = 0; i < listExtractedAppBundles.length; i++) {
    for (int j = 0; j < listExtractedAppBundles[i].listSlaves.length; j++) {
      listSlaves.add(listExtractedAppBundles[i].listSlaves[j]);
      listStateProviders.add(mapAllDevicesStateProvider[listSlaves[j]]!);
    }
  }
}


// Container(
//                     height: 200,
//                     color: Colors.amber,
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           const Text('Modal BottomSheet'),
//                           ElevatedButton(
//                             child: const Text('Close BottomSheet'),
//                             onPressed: () => Navigator.pop(context),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );