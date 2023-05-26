// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:adomob/my_widgets/thermostat/publish_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../my_models/complex_state_fz.dart';
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

    for (index = 0; index < listStateProviders.length; index++) {
      JsonForMqtt intermediate = ref.watch(listStateProviders[index]);
      //  if (intermediate.teleJsonMap.isNotEmpty && intermediate.teleJsonMap.containsKey('Name')) {
      mapState.addAll({intermediate.deviceId: intermediate});
      //  }
    }

    setTable_1();

    return Thermostat(listSlaves, ref, mapState);
  }
}

class Thermostat extends StatelessWidget {
  const Thermostat(this.listSlaves, this.ref, this.mapState, {super.key});
  final List<String> listSlaves;
  final WidgetRef ref;
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
          SizedBox(height: 30, width: MediaQuery.of(context).size.width, child: const Card(child: Text('Semaine', textAlign: TextAlign.center))),
          SetUpRowTemperature(
            listSlaves: listSlaves,
            periode: 'SEMAINE',
            ref: ref,
            mapState: mapState,
          ),
          SizedBox(height: 30, width: MediaQuery.of(context).size.width, child: const Card(child: Text('Week-end', textAlign: TextAlign.center))),
          SetUpRowTemperature(
            periode: 'WEEKEND',
            listSlaves: listSlaves,
            ref: ref,
            mapState: mapState,
          ),
          SizedBox(height: 30, width: MediaQuery.of(context).size.width, child: const Card(child: Text('Absence', textAlign: TextAlign.center))),
          SetUpRowAway(
            listSlaves: listSlaves,
            ref: ref,
            mapState: mapState,
          ),
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

class SetUpRowTemperature extends StatefulWidget {
  const SetUpRowTemperature({
    Key? key,
    required this.periode,
    required this.listSlaves,
    required this.ref,
    required this.mapState,
  }) : super(key: key);
  final List<String> listSlaves;
  final String periode;
  final WidgetRef ref;
  final Map<String, JsonForMqtt> mapState;

  @override
  State<SetUpRowTemperature> createState() => _SetUpRowTemperatureState();
}

class _SetUpRowTemperatureState extends State<SetUpRowTemperature> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: TemperatureWheelWidget(
              slot: 'MATIN',
              periode: widget.periode,
              listSlaves: widget.listSlaves,
              ref: widget.ref,
              mapState: widget.mapState,
            ),
          ),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: TemperatureWheelWidget(
              slot: 'JOURNEE',
              periode: widget.periode,
              listSlaves: widget.listSlaves,
              ref: widget.ref,
              mapState: widget.mapState,
            ),
          ),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: TemperatureWheelWidget(
              slot: 'SOIR',
              periode: widget.periode,
              listSlaves: widget.listSlaves,
              ref: widget.ref,
              mapState: widget.mapState,
            ),
          ),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: TemperatureWheelWidget(
              slot: 'NUIT',
              periode: widget.periode,
              listSlaves: widget.listSlaves,
              ref: widget.ref,
              mapState: widget.mapState,
            ),
          )
        ],
      ),
    );
  }
}

class SetUpRowAway extends StatelessWidget {
  const SetUpRowAway({
    Key? key,
    required this.listSlaves,
    required this.ref,
    required this.mapState,
  }) : super(key: key);
  final List<String> listSlaves;
  final WidgetRef ref;
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
          AwayTemperatureWheelWidget(
            slot: 'Température',
            periode: 'AWAY',
            listSlaves: listSlaves,
            ref: ref,
            mapState: mapState,
          ),
          AwayHumidityWidget(
            listSlaves: listSlaves,
            ref: ref,
            mapState: mapState,
          ),
        ],
      ),
    );
  }
}

// ****************************************************************************
// *          WHEELS PICKERS
// ****************************************************************************
class TemperatureWheelWidget extends StatelessWidget {
  const TemperatureWheelWidget({
    Key? key,
    required this.slot,
    required this.listSlaves,
    required this.ref,
    required this.mapState,
    required this.periode,
  }) : super(key: key);
  final String slot;
  final String periode;
  final List<String> listSlaves;
  final WidgetRef ref;
  final Map<String, JsonForMqtt> mapState;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTextStyle(
          style: TextStyle(
            color: CupertinoColors.label.resolveFrom(context),
            fontSize: 8.0,
          ),
          child: SizedBox(
            height: 150,
            width: 80,
            child: CupertinoPicker(
              diameterRatio: 1.1,
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              scrollController: FixedExtentScrollController(initialItem: startingItems[periode]?[slot] ?? 1),
              itemExtent: 22,
              onSelectedItemChanged: (int selectedItem) {
                switch (periode) {
                  case 'SEMAINE':
                    tabSemaine[slot] = itemsTempPresent[selectedItem];
                    break;
                  case 'WEEKEND':
                    tabWeekend[slot] = itemsTempPresent[selectedItem];
                    break;
                }
              },
              children: const [
                Text('22°C'),
                Text('21°C'),
                Text('20°C'),
                Text('19°C'),
                Text('18°C'),
                Text('17°C'),
                Text('16°C'),
              ],
            ),
          ),
        ),
        Text(slot),
      ],
    );
  }
}

class AwayHumidityWidget extends StatelessWidget {
  const AwayHumidityWidget({
    Key? key,
    required this.listSlaves,
    required this.ref,
    required this.mapState,
  }) : super(key: key);
  final List<String> listSlaves;
  final WidgetRef ref;
  final Map<String, JsonForMqtt> mapState;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTextStyle(
          style: TextStyle(
            color: CupertinoColors.label.resolveFrom(context),
            fontSize: 8.0,
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 150, maxWidth: 80),
            child: SizedBox(
              height: 150,
              width: 80,
              child: CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                scrollController: FixedExtentScrollController(initialItem: startingItems['AWAY']?['HUMIDITE'] ?? 1),
                itemExtent: 22,
                onSelectedItemChanged: (int selectedItem) {
                  tabAway['HUMIDITE'] = itemsHumAway[selectedItem];
                },
                children: const [
                  Text('80%'),
                  Text('75%'),
                  Text('70%'),
                  Text('65%'),
                  Text('60%'),
                  Text('55%'),
                  Text('50%'),
                ],
              ),
            ),
          ),
        ),
        const Text('humidité')
      ],
    );
  }
}

class AwayTemperatureWheelWidget extends StatelessWidget {
  const AwayTemperatureWheelWidget({
    Key? key,
    required this.slot,
    required this.listSlaves,
    required this.ref,
    required this.mapState,
    required this.periode,
  }) : super(key: key);
  final String slot;
  final String periode;
  final List<String> listSlaves;
  final WidgetRef ref;
  final Map<String, JsonForMqtt> mapState;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTextStyle(
          style: TextStyle(
            color: CupertinoColors.label.resolveFrom(context),
            fontSize: 8.0,
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 150, maxWidth: 80),
            child: SizedBox(
              height: 150,
              width: 80,
              child: CupertinoPicker(
                diameterRatio: 1.1,
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                scrollController: FixedExtentScrollController(initialItem: startingItems['AWAY']?['TEMPERATURE'] ?? 1),
                itemExtent: 22,
                onSelectedItemChanged: (int selectedItem) {
                  tabAway['TEMPERATURE'] = itemsTempAway[selectedItem];
                },
                children: const [
                  Text('16°C'),
                  Text('15°C'),
                  Text('14°C'),
                  Text('13°C'),
                  Text('12°C'),
                  Text('11°C'),
                  Text('10C'),
                ],
              ),
            ),
          ),
        ),
        Text(slot),
      ],
    );
  }
}
