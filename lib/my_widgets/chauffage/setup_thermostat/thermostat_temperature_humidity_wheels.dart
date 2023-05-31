import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../my_notifiers/thermostat_selected_period_manager.dart';
import '../chauffage_data.dart';
import 'thermostat_data_management.dart';

// ****************************************************************************
// *          WHEELS PICKERS PRESENCE
// ****************************************************************************
class PresenceTemperatureWheel extends ConsumerWidget {
  const PresenceTemperatureWheel({
    Key? key,
    required this.slot,
    required this.listSlaves,
  }) : super(key: key);
  final String slot;
  final List<String> listSlaves;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String periode = ref.read(selectedPeriodProvider);

    FixedExtentScrollController? scrollWheelController = FixedExtentScrollController(initialItem: tabStartingItems[periode]?[slot] ?? 1);

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
              scrollController: scrollWheelController,
              itemExtent: 22,
              onSelectedItemChanged: (int selectedItem) {
                //* met a jour la table des temperatures
                tabThermostatSetup[periode]![slot] = itemsTempPresent[selectedItem];
                tabStartingItems[periode]?[slot] = selectedItem;
                for (int i = 0; i < listSlaves.length; i++) {
                  switch (periode) {
                    case 'SEMAINE':
                      mapChauffages[listSlaves[i]]?.semaine[slot] = itemsTempPresent[selectedItem];
                      break;
                    case 'WEEKEND':
                      mapChauffages[listSlaves[i]]?.weekend[slot] = itemsTempPresent[selectedItem];
                      break;
                    default:
                  }
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

// ****************************************************************************
// *          WHEELS PICKERS ABSENCE
// ****************************************************************************
class AbsenceHumidityWheel extends StatefulWidget {
  const AbsenceHumidityWheel({Key? key, required this.listSlaves}) : super(key: key);
  final List<String> listSlaves;

  @override
  State<AbsenceHumidityWheel> createState() => _AbsenceHumidityWheelState();
}

class _AbsenceHumidityWheelState extends State<AbsenceHumidityWheel> {
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
                scrollController: FixedExtentScrollController(initialItem: tabStartingItems['ABSENCE']?['HUMIDITE'] ?? 1),
                itemExtent: 22,
                onSelectedItemChanged: (int selectedItem) {
                  tabThermostatSetup['ABSENCE']!['HUMIDITE'] = itemsHumAbsence[selectedItem];
                  setState(() => tabStartingItems['ABSENCE']?['HUMIDITE'] = selectedItem);
                  for (int i = 0; i < widget.listSlaves.length; i++) {
                    mapChauffages[widget.listSlaves[i]]?.absence['HUMIDITE'] = itemsTempPresent[selectedItem];
                  }
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

class AbsenceTemperatureWheel extends StatefulWidget {
  const AbsenceTemperatureWheel({
    Key? key,
    required this.listSlaves,
    required this.slot,
  }) : super(key: key);
  final List<String> listSlaves;
  final String slot;

  @override
  State<AbsenceTemperatureWheel> createState() => _AbsenceTemperatureWheelState();
}

class _AbsenceTemperatureWheelState extends State<AbsenceTemperatureWheel> {
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
                scrollController: FixedExtentScrollController(initialItem: tabStartingItems['ABSENCE']?['TEMPERATURE'] ?? 1),
                itemExtent: 22,
                onSelectedItemChanged: (int selectedItem) {
                  tabThermostatSetup['ABSENCE']!['TEMPERATURE'] = itemsTempAbsence[selectedItem];
                  setState(() => tabStartingItems['ABSENCE']?['TEMPERATURE'] = selectedItem);
                  for (int i = 0; i < widget.listSlaves.length; i++) {
                    mapChauffages[widget.listSlaves[i]]?.absence['TEMPERATURE'] = itemsTempPresent[selectedItem];
                  }
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
        Text(widget.slot),
      ],
    );
  }
}