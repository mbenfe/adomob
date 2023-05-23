// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../my_models/complex_state_fz.dart';
import '../state_notifier.dart';

final itemsTempPresent = [22, 21, 20, 19, 18, 17, 16];
final itemsTempAway = [16, 15, 14, 13, 12, 11, 10];
final itemsHumAway = [80, 75, 70, 65, 60, 55, 50];

final Map<String, Map<String, int>> startingItems = {
  'SEMAINE': {'MATIN': 3, 'JOURNEE': 3, 'SOIR': 3, 'NUIT': 3},
  'WEEKEND': {'MATIN': 3, 'JOURNEE': 3, 'SOIR': 3, 'NUIT': 3},
  'AWAY': {'TEMPERATURE': 3, 'HUMIDITE': 3},
};

Map<String, dynamic> tabSemaine = {'MATIN': 19, 'JOURNEE': 19, 'SOIR': 19, 'NUIT': 19};
Map<String, dynamic> tabWeekend = {'MATIN': 19, 'JOURNEE': 19, 'SOIR': 19, 'NUIT': 19};
Map<String, dynamic> tabAway = {'TEMPERATURE': 13, 'HUMIDITE': 65}; // dynamic car contendra le nom du device = string

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

    Map<String, JsonForMqtt> mapState = {};

    for (index = 0; index < listStateProviders.length; index++) {
      JsonForMqtt intermediate = ref.watch(listStateProviders[index]);
      //  if (intermediate.teleJsonMap.isNotEmpty && intermediate.teleJsonMap.containsKey('Name')) {
      mapState.addAll({intermediate.deviceId: intermediate});
      //  }
    }

    List<Map<String, dynamic>> listJsonGateway = [];

    if (mapState['gateway'] != null && mapState['gateway']?.listOtherJsonMap != null) {
      if (kDebugMode) {
        listJsonGateway = mapState['gateway']!.listOtherJsonMap;
        if (listJsonGateway.isNotEmpty) {
          for (int i = 0; i < listJsonGateway.length; i++) {
            switch (listJsonGateway[i]['TYPE']) {
              case 'SEMAINE':
                startingItems['SEMAINE']?['MATIN'] = itemsTempPresent.indexOf(listJsonGateway[i]['MATIN']);
                startingItems['SEMAINE']?['JOURNEE'] = itemsTempPresent.indexOf(listJsonGateway[i]['JOURNEE']);
                startingItems['SEMAINE']?['SOIR'] = itemsTempPresent.indexOf(listJsonGateway[i]['SOIR']);
                startingItems['SEMAINE']?['NUIT'] = itemsTempPresent.indexOf(listJsonGateway[i]['NUIT']);
                break;
              case 'WEEKEND':
                startingItems['WEEKEND']?['MATIN'] = itemsTempPresent.indexOf(listJsonGateway[i]['MATIN']);
                startingItems['WEEKEND']?['JOURNEE'] = itemsTempPresent.indexOf(listJsonGateway[i]['JOURNEE']);
                startingItems['WEEKEND']?['SOIR'] = itemsTempPresent.indexOf(listJsonGateway[i]['SOIR']);
                startingItems['WEEKEND']?['NUIT'] = itemsTempPresent.indexOf(listJsonGateway[i]['NUIT']);
                break;
              case 'AWAY':
                startingItems['AWAY']?['TEMPERATURE'] = itemsTempAway.indexOf(listJsonGateway[i]['TEMPERATURE']);
                startingItems['AWAY']?['HUMIDITE'] = itemsHumAway.indexOf(listJsonGateway[i]['HUMIDITE']);
                break;
            }
          }
          print('config enregistrée');
        }
      }
    }

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
          SizedBox(
              height: 30,
              width: MediaQuery.of(context).size.width,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(child: Text('Semaine', textAlign: TextAlign.center)),
              )),
          SetUpRowTemperature(
            listSlaves: listSlaves,
            periode: 'SEMAINE',
            ref: ref,
            mapState: mapState,
          ),
          SizedBox(
              height: 30,
              width: MediaQuery.of(context).size.width,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(child: Text('Week-end', textAlign: TextAlign.center)),
              )),
          SetUpRowTemperature(
            periode: 'WEEKEND',
            listSlaves: listSlaves,
            ref: ref,
            mapState: mapState,
          ),
          SizedBox(
              height: 30,
              width: MediaQuery.of(context).size.width,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(child: Text('Absence', textAlign: TextAlign.center)),
              )),
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
                  if (kDebugMode) {
                    print('valider!!!');
                  }
                  //* publie les setting en semaine
                  for (int index = 0; index < listSlaves.length; index++) {
                    tabSemaine.update('Name', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
                    tabSemaine.update('TYPE', (value) => 'SEMAINE', ifAbsent: () => 'SEMAINE');
                    mapState[listSlaves[index]]?.classSendThermostat(listSlaves[index], 'SEMAINE', tabSemaine);
                  }
                  tabSemaine.update('Name', (value) => 'gateway', ifAbsent: () => 'gateway');
                  mapState['gateway']?.classSendThermostat('gateway', 'SEMAINE', tabSemaine); //* se le renvoi a lui meme
                  //* publie les setting en week end
                  for (int index = 0; index < listSlaves.length; index++) {
                    tabWeekend.update('Name', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
                    tabWeekend.update('TYPE', (value) => 'WEEKEND', ifAbsent: () => 'WEEKEND');
                    mapState[listSlaves[index]]?.classSendThermostat(listSlaves[index], 'WEEKEND', tabWeekend);
                  }
                  tabWeekend.update('Name', (value) => 'gateway', ifAbsent: () => 'gateway');
                  mapState['gateway']?.classSendThermostat('gateway', 'WEEKEND', tabWeekend); //* se le renvoi a lui meme
                  //* publie les setting en absence
                  for (int index = 0; index < listSlaves.length; index++) {
                    tabAway.update('Name', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
                    tabAway.update('TYPE', (value) => 'AWAY', ifAbsent: () => 'AWAY');
                    mapState[listSlaves[index]]?.classSendThermostat(listSlaves[index], 'AWAY', tabAway);
                  }
                  tabAway.update('Name', (value) => 'gateway', ifAbsent: () => 'gateway');
                  mapState['gateway']?.classSendThermostat('gateway', 'AWAY', tabAway); //* se le renvoi a lui meme
                },
                child: const Text('Valider')),
          ),
        ],
      ),
    );
  }
}

class SetUpRowTemperature extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.only(top: 6.0),
      //margin: EdgeInsets.only(
      //  bottom: MediaQuery.of(context).viewInsets.bottom,
      //),
      color: CupertinoColors.systemBackground.resolveFrom(context),
//      color: Colors.grey,

      //    color: Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TemperatureWheelWidget(
            slot: 'MATIN',
            periode: periode,
            listSlaves: listSlaves,
            ref: ref,
            mapState: mapState,
          ),
          TemperatureWheelWidget(
            slot: 'JOURNEE',
            periode: periode,
            listSlaves: listSlaves,
            ref: ref,
            mapState: mapState,
          ),
          TemperatureWheelWidget(
            slot: 'SOIR',
            periode: periode,
            listSlaves: listSlaves,
            ref: ref,
            mapState: mapState,
          ),
          TemperatureWheelWidget(
            slot: 'NUIT',
            periode: periode,
            listSlaves: listSlaves,
            ref: ref,
            mapState: mapState,
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
          child: Container(
            constraints: const BoxConstraints(maxHeight: 150, maxWidth: 1000),
            decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
            child: SizedBox(
              height: 150,
              width: 80,
              child: CupertinoPicker(
                //              backgroundColor: Colors.amber,
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
                  Text('22°C', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('21°C', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('20°C', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('19°C', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('18°C', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('17°C', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('16°C', style: TextStyle(color: Colors.white, fontSize: 16)),
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
            //         decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
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
                  Text('80%', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('75%', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('70%', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('65%', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('60', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('55', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('50', style: TextStyle(color: Colors.white, fontSize: 16)),
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
            //       decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
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
                  Text('16°C', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('15°C', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('14°C', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('13°C', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('12°C', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('11°C', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('10C', style: TextStyle(color: Colors.white, fontSize: 16)),
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
