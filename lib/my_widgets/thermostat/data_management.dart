import 'package:flutter/foundation.dart';

import '../../my_models/complex_state_fz.dart';

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

Map<String, JsonForMqtt> mapState = {};
List<Map<String, dynamic>> listJsonGateway = [];

void setTable_1() {
  if (mapState['gateway'] != null && mapState['gateway']?.listOtherJsonMap != null) {
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
      if (kDebugMode) {
        print('config enregistrée');
      }
    }
  }
}
