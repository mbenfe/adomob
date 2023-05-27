import 'package:flutter/foundation.dart';

import 'data_management.dart';

void publishSettings(List<String> listSlaves) {
  if (kDebugMode) {
    print('valider!!!');
  }
  //* publie les setting en semaine
  for (int index = 0; index < listSlaves.length; index++) {
    tabSetup['SEMAINE']?.update('Name', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    tabSetup['SEMAINE']?.update('TYPE', (value) => 'SEMAINE', ifAbsent: () => 'SEMAINE');
    mapState[listSlaves[index]]?.classSendThermostat(listSlaves[index], 'SEMAINE', tabSetup['SEMAINE']!);
  }
  tabSetup['SEMAINE']?.update('Name', (value) => 'gateway', ifAbsent: () => 'gateway');
  mapState['gateway']?.classSendThermostat('gateway', 'SEMAINE', tabSetup['SEMAINE']!); //* se le renvoi a lui meme
  //* publie les setting en week end
  for (int index = 0; index < listSlaves.length; index++) {
    tabSetup['WEEKEND']?.update('Name', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    tabSetup['WEEKEND']?.update('TYPE', (value) => 'WEEKEND', ifAbsent: () => 'WEEKEND');
    mapState[listSlaves[index]]?.classSendThermostat(listSlaves[index], 'WEEKEND', tabSetup['WEEKEND']!);
  }
  tabSetup['WEEKEND']?.update('Name', (value) => 'gateway', ifAbsent: () => 'gateway');
  mapState['gateway']?.classSendThermostat('gateway', 'WEEKEND', tabSetup['WEEKEND']!); //* se le renvoi a lui meme
  //* publie les setting en absence
  for (int index = 0; index < listSlaves.length; index++) {
    tabSetup['ABSENCE']?.update('Name', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    tabSetup['ABSENCE']?.update('TYPE', (value) => 'ABSENCE', ifAbsent: () => 'ABSENCE');
    mapState[listSlaves[index]]?.classSendThermostat(listSlaves[index], 'ABSENCE', tabSetup['ABSENCE']!);
  }
  tabSetup['ABSENCE']?.update('Name', (value) => 'gateway', ifAbsent: () => 'gateway');
  mapState['gateway']?.classSendThermostat('gateway', 'ABSENCE', tabSetup['ABSENCE']!); //* se le renvoi a lui meme
}
