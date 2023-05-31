import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../m_build_from_json.dart';
import '../../my_models/complex_state_fz.dart';
import '../../my_notifiers/widgets_manager.dart';
import 'setup_thermostat/thermostat.dart';
import 'chauffage_data.dart';
import 'chauffage_notifiers.dart';
import 'setup_thermostat/thermostat_publish_settings.dart';

class TopWidgetChauffage extends ConsumerStatefulWidget {
  const TopWidgetChauffage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopWidgetChauffageState();
}

class _TopWidgetChauffageState extends ConsumerState<TopWidgetChauffage> {
  @override
  Widget build(BuildContext context) {
    String firstKey = mapChauffages.keys.toList().first;
    var state = ref.watch(mapAllDevicesStateProvider[firstKey]!);

    if (state.listOtherJsonMap.isNotEmpty) {
      var rep = state.listOtherJsonMap.firstWhere((element) => element['TYPE'] == 'MODE', orElse: () => {});
      if (rep.isNotEmpty) {
        var index = labels.indexOf(rep['Mode']);
        chauffageModeValue = index.toDouble(); //rep['Mode'];
      }
    }

    return Card(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Flexible(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: SfSliderTheme(
            data: SfSliderThemeData(
              inactiveTrackColor: Theme.of(context).primaryColor,
              activeTrackColor: Theme.of(context).primaryColor,
              activeTrackHeight: 0,
              inactiveTrackHeight: 0,
            ),
            child: SfSlider(
              activeColor: tabColors[labels[chauffageModeValue.toInt()]],

//              activeColor: Colors.red,
              min: 0,
              max: 2,
              edgeLabelPlacement: EdgeLabelPlacement.auto,
              stepSize: 1,
              showLabels: true,
              value: chauffageModeValue,
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
              onChanged: (dynamic newValue) {
                setState(() {
                  publishMode(labels[newValue.toInt()]);
                });
                //              periodeNotifier.state = Periode(selectedPeriode);
              },
            ),
          ),
        ),
      ),
      SetGlobalThermostat(
        ref: ref,
      ),
    ]));
  }
}

class SetGlobalThermostat extends ConsumerWidget {
  const SetGlobalThermostat({required this.ref, super.key});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      flex: 2,
      child: IconButton(
        onPressed: () {
          ref.read(chauffageSetupLaunchProvider.notifier).state = true;
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return const ModalRootThermostatWidget(
                master: 'global',
              );
            },
          );
        },
        icon: const Icon(MdiIcons.homeThermometerOutline),
      ),
    );
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

List<String> extractListSlaves(String master) {
  List<String> listSlaves = [];
  //* selection des esclaves chauffage
  List<Bundle> listExtractedAppBundles = listBundles.where((element) => element.type == 'Chauffage').toList();
  // construction des list esclaves selon le cas thermostat global ou pour une piece
  int i;
  switch (master.toUpperCase()) {
    case 'GLOBAL':
      mapPiecesLinked.forEach((key, value) {
        if (value == true) {
          // piece 'linkée' au thermostat global
          var bundle = listExtractedAppBundles.firstWhere((element) => element.master == key);
          for (i = 0; i < bundle.listSlaves.length; i++) {
            listSlaves.add(bundle.listSlaves[i]);
          }
        }
      });
      break;
    default:
      var bundle = listExtractedAppBundles.firstWhere((element) => element.master == master);
      for (i = 0; i < bundle.listSlaves.length; i++) {
        listSlaves.add(bundle.listSlaves[i]);
      }
      break;
  }
  return listSlaves;
}

List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> extractListProviders(List<String> listSlaves) {
  List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> list = [];
  for (int i = 0; i < listSlaves.length; i++) {
    list.add(mapAllDevicesStateProvider[listSlaves[i]]!);
  }
  return list;
}
