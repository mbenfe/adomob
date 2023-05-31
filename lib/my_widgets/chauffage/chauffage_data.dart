import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../m_build_from_json.dart';

class Chauffage {
  String mode = 'AUTO';
  Map<String, dynamic> semaine = {'MATIN': 19, 'JOURNEE': 19, 'SOIR': 19, 'NUIT': 19};
  Map<String, dynamic> weekend = {'MATIN': 19, 'JOURNEE': 19, 'SOIR': 19, 'NUIT': 19};
  Map<String, dynamic> absence = {'TEMPERATURE': 13, 'HUMIDITE': 65};
}

double chauffageModeValue = 1;

Map<String, Chauffage> mapChauffages = {};
Map<String, dynamic> mapPiecesLinked = {};

List<String> labels = ['MANUEL', 'AUTO', 'ABSENCE'];

final Map<String, Color> tabColors = {'MANUEL': Colors.grey, 'AUTO': Colors.green, 'ABSENCE': Colors.amber};

final setupThermostatProvider = StateProvider<bool>((ref) {
  return false;
});

void buildChauffagesConfigurations() {
  int i, j;
  if (kDebugMode) {
    print('build chauffages configurations');
  }
  //* selection des esclaves chauffage
  List<Bundle> listExtractedAppBundles = listBundles.where((element) => element.type == 'Chauffage').toList();
  for (i = 0; i < listExtractedAppBundles.length; i++) {
    mapPiecesLinked.addAll({listExtractedAppBundles[i].master: true});
    for (j = 0; j < listExtractedAppBundles[i].listSlaves.length; j++) {
      mapChauffages.addAll({listExtractedAppBundles[i].listSlaves[j]: Chauffage()});
    }
  }
  mapChauffages.forEach((key, value) {
    value.mode = labels[chauffageModeValue.toInt()];
  });
}
