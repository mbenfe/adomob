import 'package:flutter/foundation.dart';

import '../../my_models/complex_state_fz.dart';

bool isSemaine = false;

//* tableau des correspondance temp/index et hum/index
final itemsTempPresent = [22, 21, 20, 19, 18, 17, 16];
final itemsTempAbsence = [16, 15, 14, 13, 12, 11, 10];
final itemsHumAbsence = [80, 75, 70, 65, 60, 55, 50];

//* tableau dynamique du positionnement dans la roue
final Map<String, Map<String, int>> tabStartingItems = {
  'SEMAINE': {'MATIN': 3, 'JOURNEE': 3, 'SOIR': 3, 'NUIT': 3},
  'WEEKEND': {'MATIN': 3, 'JOURNEE': 3, 'SOIR': 3, 'NUIT': 3},
  'ABSENCE': {'TEMPERATURE': 3, 'HUMIDITE': 3},
};

//* tableau dynamique du setup final
Map<String, Map<String, dynamic>> tabSetup = {
  'SEMAINE': {'MATIN': 19, 'JOURNEE': 19, 'SOIR': 19, 'NUIT': 19},
  'WEEKEND': {'MATIN': 19, 'JOURNEE': 19, 'SOIR': 19, 'NUIT': 19},
  'ABSENCE': {'TEMPERATURE': 16, 'HUMIDITE': 65}
};

Map<String, JsonForMqtt> mapState = {};
List<Map<String, dynamic>> listJsonGateway = [];

void conversionJsonOther() {
  if (mapState['gateway'] != null && mapState['gateway']?.listOtherJsonMap != null) {
    listJsonGateway = mapState['gateway']!.listOtherJsonMap;
    if (listJsonGateway.isNotEmpty) {
      for (int i = 0; i < listJsonGateway.length; i++) {
        switch (listJsonGateway[i]['TYPE']) {
          case 'SEMAINE':
            tabStartingItems['SEMAINE']?['MATIN'] = itemsTempPresent.indexOf(listJsonGateway[i]['MATIN']);
            tabStartingItems['SEMAINE']?['JOURNEE'] = itemsTempPresent.indexOf(listJsonGateway[i]['JOURNEE']);
            tabStartingItems['SEMAINE']?['SOIR'] = itemsTempPresent.indexOf(listJsonGateway[i]['SOIR']);
            tabStartingItems['SEMAINE']?['NUIT'] = itemsTempPresent.indexOf(listJsonGateway[i]['NUIT']);
            break;
          case 'WEEKEND':
            tabStartingItems['WEEKEND']?['MATIN'] = itemsTempPresent.indexOf(listJsonGateway[i]['MATIN']);
            tabStartingItems['WEEKEND']?['JOURNEE'] = itemsTempPresent.indexOf(listJsonGateway[i]['JOURNEE']);
            tabStartingItems['WEEKEND']?['SOIR'] = itemsTempPresent.indexOf(listJsonGateway[i]['SOIR']);
            tabStartingItems['WEEKEND']?['NUIT'] = itemsTempPresent.indexOf(listJsonGateway[i]['NUIT']);
            break;
          case 'ABSENCE':
            tabStartingItems['ABSENCE']?['TEMPERATURE'] = itemsTempAbsence.indexOf(listJsonGateway[i]['TEMPERATURE']);
            tabStartingItems['ABSENCE']?['HUMIDITE'] = itemsHumAbsence.indexOf(listJsonGateway[i]['HUMIDITE']);
            break;
        }
      }
      if (kDebugMode) {
        print('config enregistrée');
      }
    }
  }
}
