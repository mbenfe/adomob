// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:adomob/my_widgets/chauffage/setup_thermostat/thermostat_data_management.dart';
import 'package:adomob/my_widgets/chauffage/setup_thermostat/thermostat_publish_settings.dart';
import 'package:adomob/my_widgets/chauffage/setup_thermostat/thermostat_slider.dart';
import 'package:adomob/my_widgets/chauffage/setup_thermostat/thermostat_temperature_humidity_wheels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../my_models/complex_state_fz.dart';
import '../../../my_notifiers/thermostat_selected_period_manager.dart';
import '../../../my_notifiers/widgets_manager.dart';
import '../top_widget_chauffage.dart';

class ModalRootThermostatWidget extends ConsumerWidget {
  const ModalRootThermostatWidget({required this.master, Key? key}) : super(key: key);
  final String master;

  @override
  Widget build(BuildContext context, ref) {
    final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
    final List<String> listSlaves;
    ref.watch(selectedPeriodProvider);

    listSlaves = extractListSlaves(master);
    listStateProviders = extractListProviders(listSlaves);

    for (int index = 0; index < listStateProviders.length; index++) {
      JsonForMqtt intermediate = ref.watch(listStateProviders[index]);
      //  if (intermediate.teleJsonMap.isNotEmpty && intermediate.teleJsonMap.containsKey('Name')) {
      mapState.addAll({intermediate.deviceId: intermediate});
      //  }
    }

    //* consider seulement le premier escalves (les autres sont alignés)
    conversionJsonOther(listSlaves[0]);

//    return Dialog(shape: const ContinuousRectangleBorder(), child: Thermostat(listSlaves, mapState));
    return ModalThermostat(listSlaves);
  }
}

class ModalThermostat extends ConsumerWidget {
  const ModalThermostat(this.listSlaves, {super.key});
  final List<String> listSlaves;

  //final Map<String, JsonForMqtt> mapState;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode) {
      print(listSlaves.toString());
    }
    ref.watch(selectedPeriodProvider);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const ModalPeriodeSelectionSlider(),
          ModalDirectToWidget(listSlaves: listSlaves),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  publishThermostatSettings(listSlaves);
                  Navigator.pop(context);
                },
                child: const Text('Valider')),
          ),
        ],
      ),
    );
  }
}

class ModalDirectToWidget extends ConsumerWidget {
  const ModalDirectToWidget({required this.listSlaves, super.key});
  final List<String> listSlaves;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedPeriodProvider);
    switch (selectedPeriode) {
      case 'SEMAINE':
        return SetUpRowTemperatureSemaine(
          listSlaves: listSlaves,
        );
      case 'WEEKEND':
        return SetUpRowTemperatureWeekend(
          listSlaves: listSlaves,
        );
      case 'ABSENCE':
        return const SetUpRowAbsence(
          listSlaves: [],
          mapState: {},
        );
    }
    return Container();
  }
}

class SetUpRowTemperatureWeekend extends ConsumerWidget {
  const SetUpRowTemperatureWeekend({Key? key, required this.listSlaves}) : super(key: key);

  final List<String> listSlaves;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedPeriodProvider);
    return Column(
      children: [
        Container(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  listSlaves: listSlaves,
                  slot: 'MATIN',
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  listSlaves: listSlaves,
                  slot: 'JOURNEE',
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  listSlaves: listSlaves,
                  slot: 'SOIR',
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  listSlaves: listSlaves,
                  slot: 'NUIT',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SetUpRowTemperatureSemaine extends ConsumerWidget {
  const SetUpRowTemperatureSemaine({
    Key? key,
    required this.listSlaves,
  }) : super(key: key);
  final List<String> listSlaves;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedPeriodProvider);
    return Column(
      children: [
        Container(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  listSlaves: listSlaves,
                  slot: 'MATIN',
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  listSlaves: listSlaves,
                  slot: 'JOURNEE',
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  listSlaves: listSlaves,
                  slot: 'SOIR',
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  listSlaves: listSlaves,
                  slot: 'NUIT',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SetUpRowAbsence extends StatelessWidget {
  const SetUpRowAbsence({
    Key? key,
    required this.listSlaves,
    required this.mapState,
  }) : super(key: key);
  final List<String> listSlaves;
  final Map<String, JsonForMqtt> mapState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AbsenceTemperatureWheel(
            listSlaves: listSlaves,
            slot: 'Température',
          ),
          AbsenceHumidityWheel(listSlaves: listSlaves),
        ],
      ),
    );
  }
}
