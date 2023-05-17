import 'package:flutter/foundation.dart';
import 'package:my_adomob/m_define.dart';
import 'package:my_mqtt/mqtt_handler.dart';

void commande(bool isOn, List<bool> fanSpeed, List<bool> modeSelected, double temperature, List<String> listDeviceId) {
  int i;
  String token = "";
  String topic = "gw/$client/$lieu/cmnd/GW/ZbSend";
  String payload = "";

  int eqFanSpeed = 0;
  int eqModeSelected = 0;

  // defini la vitesse ventilateur
  for (i = 0; i < fanSpeed.length; i++) {
    if (fanSpeed[i] == true) {
      eqFanSpeed = i;
      break;
    }
  }
  // defini le mode de la clim
  for (i = 0; i < modeSelected.length; i++) {
    if (modeSelected[i] == true) {
      eqModeSelected = i;
      break;
    }
  }

  for (i = 0; i < listDeviceId.length; i++) {
    // envoi temperature
    token = "\"0006_02/00AD20${temperature.toInt().toRadixString(16)}\""; // envoi la temperature attr: AD00
    payload = '{"Device":"${listDeviceId[i]}","send":$token}';
    publishMqtt(topic, payload);
    if (kDebugMode) {
      print("temperature -> topic: $topic payload:$payload");
    }
    // envoi mode
    token = "\"0006_02/01AD20${eqModeSelected.toString().padLeft(2, '0')}\""; // envoi le mode attr: AD01
    payload = '{"Device":"${listDeviceId[i]}","send":$token}';
    publishMqtt(topic, payload);
    if (kDebugMode) {
      print("mode -> topic: $topic payload:$payload");
    }
    // envoi fan
    token = "\"0006_02/02AD20${eqFanSpeed.toString().padLeft(2, '0')}\""; // envoi fan mode attr: AD02
    payload = '{"Device":"${listDeviceId[i]}","send":$token}';
    publishMqtt(topic, payload);
    if (kDebugMode) {
      print("fan -> topic: $topic payload:$payload");
    }
    // envoi la commande
//    payload = '{"Device":"${listDeviceId[i]}","send":{"Power":"Toggle"}}';
    payload = '{"Device":"${listDeviceId[i]}","send":{"Power":$isOn}}';
    publishMqtt(topic, payload);
  }

  if (kDebugMode) {
    print("topic: $topic");
    print("payload:$payload");
  }
}
