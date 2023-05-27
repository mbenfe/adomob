// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:adomob/my_widgets/thermostat/publish_settings.dart';
import 'package:adomob/my_widgets/thermostat/slider.dart';
import 'package:adomob/my_widgets/thermostat/temperature_humidity_wheels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../my_models/complex_state_fz.dart';
import '../../my_notifiers/thermostat_selected_period_manager.dart';
import '../../my_notifiers/widgets_manager.dart';
import 'data_management.dart';

class RootThermostatWidget extends ConsumerWidget {
  const RootThermostatWidget({required this.master, required this.listSlaves, required this.location, required this.listStateProviders, Key? key})
      : super(key: key);
  final String master;
  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;

  @override
  Widget build(BuildContext context, ref) {
    int index;

    var notifier = ref.watch(selectedPeriodProvider);

    for (index = 0; index < listStateProviders.length; index++) {
      JsonForMqtt intermediate = ref.watch(listStateProviders[index]);
      //  if (intermediate.teleJsonMap.isNotEmpty && intermediate.teleJsonMap.containsKey('Name')) {
      mapState.addAll({intermediate.deviceId: intermediate});
      //  }
    }

    conversionJsonOther();

    return Thermostat(listSlaves, mapState);
  }
}

class Thermostat extends StatelessWidget {
  const Thermostat(this.listSlaves, this.mapState, {super.key});
  final List<String> listSlaves;
  final Map<String, JsonForMqtt> mapState;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(listSlaves.toString());
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const PeriodeSelectionSlider(),
          DirectToWidget(listSlaves, mapState),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  publishSettings(listSlaves);
                },
                child: const Text('Valider')),
          ),
        ],
      ),
    );
  }
}

class DirectToWidget extends StatelessWidget {
  const DirectToWidget(List<String> listSlaves, Map<String, JsonForMqtt> mapState, {super.key});

  @override
  Widget build(BuildContext context) {
    switch (selectedPeriode) {
      case 'SEMAINE':
        return const SetUpRowTemperatureSemaine(
          listSlaves: [],
          mapState: {},
        );
      case 'WEEKEND':
        return const SetUpRowTemperatureWeekend(
          listSlaves: [],
          mapState: {},
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
  const SetUpRowTemperatureWeekend({
    Key? key,
    required this.listSlaves,
    required this.mapState,
  }) : super(key: key);
  final List<String> listSlaves;
  final Map<String, JsonForMqtt> mapState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var notifier = ref.watch(selectedPeriodProvider);
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
                  slot: 'MATIN',
                  listSlaves: listSlaves,
                  mapState: mapState,
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  slot: 'JOURNEE',
                  listSlaves: listSlaves,
                  mapState: mapState,
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  slot: 'SOIR',
                  listSlaves: listSlaves,
                  mapState: mapState,
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  slot: 'NUIT',
                  listSlaves: listSlaves,
                  mapState: mapState,
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
    required this.mapState,
  }) : super(key: key);
  final List<String> listSlaves;
  final Map<String, JsonForMqtt> mapState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var notifier = ref.watch(selectedPeriodProvider);
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
                  slot: 'MATIN',
                  listSlaves: listSlaves,
                  mapState: mapState,
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  slot: 'JOURNEE',
                  listSlaves: listSlaves,
                  mapState: mapState,
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  slot: 'SOIR',
                  listSlaves: listSlaves,
                  mapState: mapState,
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PresenceTemperatureWheel(
                  slot: 'NUIT',
                  listSlaves: listSlaves,
                  mapState: mapState,
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
            slot: 'Température',
            periode: 'ABSENCE',
            listSlaves: listSlaves,
            mapState: mapState,
          ),
          AbsenceHumidityWheel(
            listSlaves: listSlaves,
            mapState: mapState,
          ),
        ],
      ),
    );
  }
}
