import 'package:flutter/foundation.dart';

import 'data_management.dart';

void publishSettings(List<String> listSlaves) {
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
}
