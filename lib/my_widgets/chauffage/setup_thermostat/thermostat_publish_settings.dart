import 'dart:convert';

import 'package:adomob/my_widgets/chauffage/chauffage_data.dart';
import 'package:flutter/foundation.dart';

import '../../../m_define.dart';
import '../../../my_mqtt/mqtt_handler.dart';

void classSendThermostat(String targetDevice, String period, Map<String, dynamic> tab) {
  String topic = "gw/$client/$ville/$targetDevice/tele/$period";
  String payload = tab.toString();
  payload = jsonEncode(tab);
  publishMqtt(topic, payload);
}

//************************ publish MQTT  ********************************************/
void publishThermostatSettings(List<String> listSlaves) {
  if (kDebugMode) {
    print('valider!!!');
  }
  //* publie les setting en semaine
  for (int index = 0; index < listSlaves.length; index++) {
    mapChauffages[listSlaves[index]]!.semaine.update('Name', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    //* ajout "Device" pour eviter le filtrage en reception
    mapChauffages[listSlaves[index]]!.semaine.update('Device', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    mapChauffages[listSlaves[index]]!.semaine.update('TYPE', (value) => 'SEMAINE', ifAbsent: () => 'SEMAINE');
    classSendThermostat(listSlaves[index], 'SEMAINE', mapChauffages[listSlaves[index]]!.semaine);
//    tabThermostatSetup['SEMAINE']?.update('Name', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
//    tabThermostatSetup['SEMAINE']?.update('Device', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
//    tabThermostatSetup['SEMAINE']?.update('TYPE', (value) => 'SEMAINE', ifAbsent: () => 'SEMAINE');
//    classSendThermostat(listSlaves[index], 'SEMAINE', tabThermostatSetup['SEMAINE']!);
  }

  //! a supprimer
//  tabThermostatSetup['SEMAINE']?.update('Name', (value) => 'gateway', ifAbsent: () => 'gateway');
//  classSendThermostat('gateway', 'SEMAINE', tabThermostatSetup['SEMAINE']!); //* se le renvoi a lui meme
  //* publie les setting en week end
  for (int index = 0; index < listSlaves.length; index++) {
    mapChauffages[listSlaves[index]]!.weekend.update('Name', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    //* ajout "Device" pour eviter le filtrage en reception
    mapChauffages[listSlaves[index]]!.weekend.update('Device', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    mapChauffages[listSlaves[index]]!.weekend.update('TYPE', (value) => 'WEEKEND', ifAbsent: () => 'WEEKEND');
    classSendThermostat(listSlaves[index], 'WEEKEND', mapChauffages[listSlaves[index]]!.weekend);
    // tabThermostatSetup['WEEKEND']?.update('Name', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    // //* ajout "Device" pour eviter le filtrage en reception
    // tabThermostatSetup['WEEKEND']?.update('Device', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    // tabThermostatSetup['WEEKEND']?.update('TYPE', (value) => 'WEEKEND', ifAbsent: () => 'WEEKEND');
    // classSendThermostat(listSlaves[index], 'WEEKEND', tabThermostatSetup['WEEKEND']!);
  }
//  tabThermostatSetup['WEEKEND']?.update('Name', (value) => 'gateway', ifAbsent: () => 'gateway');
//  classSendThermostat('gateway', 'WEEKEND', tabThermostatSetup['WEEKEND']!); //* se le renvoi a lui meme
  //* publie les setting en absence
  for (int index = 0; index < listSlaves.length; index++) {
    mapChauffages[listSlaves[index]]!.absence.update('Name', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    //* ajout "Device" pour eviter le filtrage en reception
    mapChauffages[listSlaves[index]]!.absence.update('Device', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    mapChauffages[listSlaves[index]]!.absence.update('TYPE', (value) => 'ABSENCE', ifAbsent: () => 'ABSENCE');
    classSendThermostat(listSlaves[index], 'ABSENCE', mapChauffages[listSlaves[index]]!.absence);
    // tabThermostatSetup['ABSENCE']?.update('Name', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    // //* ajout "Device" pour eviter le filtrage en reception
    // tabThermostatSetup['ABSENCE']?.update('Device', (value) => listSlaves[index], ifAbsent: () => listSlaves[index]);
    // tabThermostatSetup['ABSENCE']?.update('TYPE', (value) => 'ABSENCE', ifAbsent: () => 'ABSENCE');
    // classSendThermostat(listSlaves[index], 'ABSENCE', tabThermostatSetup['ABSENCE']!);
  }
//  tabThermostatSetup['ABSENCE']?.update('Name', (value) => 'gateway', ifAbsent: () => 'gateway');
//  classSendThermostat('gateway', 'ABSENCE', tabThermostatSetup['ABSENCE']!); //* se le renvoi a lui meme
}

void publishLinked(String master) {
  String topic = "gw/$client/$ville/$master/tele/LINKED";
  Map<String, dynamic> map = {};
  map.addAll({'TYPE': 'LINKED'});
  map.addAll({'Device': master});
  map.addAll({'Name': master});
  map.addAll({'Linked': mapPiecesLinked[master]});
  String payload = '';
  payload = jsonEncode(map);
  publishMqtt(topic, payload);
}

void publishMode(String mode) {
  String topic = '';
  String payload = '';
  mapChauffages.forEach((key, value) {
    topic = "gw/$client/$ville/$key/tele/MODE";
    Map<String, dynamic> map = {};
    map.addAll({'TYPE': 'MODE'});
    map.addAll({'Device': key});
    map.addAll({'Name': key});
    map.addAll({'Mode': mode});
    payload = jsonEncode(map);
    publishMqtt(topic, payload);
  });
}
