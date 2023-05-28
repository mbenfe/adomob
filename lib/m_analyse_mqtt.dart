import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'm_build_from_json.dart';
import 'my_mqtt/mqtt_handler.dart';
import 'my_notifiers/widgets_manager.dart';

int countMqttMessages = 0, countTeleMessages = 0, countOtherMessages = 0;

//void appAnalyseReceivedMqtt(String topic, String payload, WidgetRef ref) {
void appAnalyseReceivedMqtt(String topic, String payload) {
  MqttTelegram message = MqttTelegram();

  countMqttMessages++;
  message.topicRoot = topic.split('/')[0];
  message.topicCustomer = topic.split('/')[1];
  message.topicLocation = topic.split('/')[2];
  message.topicDevice = topic.split('/')[3];
  message.topicType = topic.split('/')[4];
  if (message.topicType == 'tele') {
    message.mesureFlag = topic.split('/')[5];
  }
  message.payload = payload;

  /// format messages adomob = [gw/app_cfg]]/nom/lieu/[device]/tele/[XXXX etc ....

  //print('$countTeleMessages + $countOtherMessages : $countMqttMessages - Buffer:$countBufferMqtt');
  //! filter print
  //if (kDebugMode) print("RECU:topic: $topic: payload : ${message.payload}");
  // filtre
  if (payload == "") return;

  switch (message.topicType) {
    case "appCfg": // client/lieu/dummy/appCfg
      //   analyseReceivedAppCfgJson(message.payload);
      break;
    case "appCfg2": // client/lieu/dummy/appCfg
      if (kDebugMode) print("topic: $topic: payload : ${message.payload}");
      analyseReceivedAppCfgJson2(message.payload);
      break;
    case "tele":
      switch (message.mesureFlag) {
        case 'SENSOR':
          analyseTeleJsonPayload(message.payload);
          break;
        case 'ABSENCE':
        case 'SEMAINE':
        case 'WEEKEND':
          if (kDebugMode) {
            print('RECU:THERMOSTAT:$countMqttMessages -------- $topic ------- $payload');
          }

          analyseOtherJsonPayload(message.payload);
          break;
        case 'PWDAYS':
        case 'PWHOURS':
        case 'PWMONTHS':
          analyseOtherJsonPayload(message.payload);
          break;
        default:
          break;
      }
      break;
    default:
      break;
  }

  if (bufferMqtt.isNotEmpty) {
    mapAllDevicesSubStateNotifier.forEach((key, value) {
      emptyMqttBuffer(key, value);
    });
  }
}

//*  ANALYSE JSON telemetry ***************************/
void analyseTeleJsonPayload(String jsonText) {
  Map<String, dynamic> jsonMap = json.decode(jsonText);
  if (jsonMap['Device'] == null) {
    return;
  }

  countTeleMessages++;
  if (checkSonoffTemperature(jsonMap) == true) return;

  WidgetMqttStateNotifier? myStateNotifier = mapAllDevicesSubStateNotifier[jsonMap['Name']];

  jsonMap['TYPE'] = 'SENSOR';
  if (myStateNotifier != null) {
    jsonMap.remove('Device');
    jsonMap.remove('Endpoint');
    // add indication to the widget that it is a sensor result
    myStateNotifier.stateUpdateTeleJsonMap(jsonMap);
    emptyAssociatedNotifierFromBufferMqtt(jsonMap, myStateNotifier);
  } else {
    updateBufferMqtt(jsonMap);
  }
}

//*  ANALYSE JSON AUTRES ***************************/
void analyseOtherJsonPayload(String jsonText) {
  Map<String, dynamic> jsonMap = json.decode(jsonText);
  WidgetMqttStateNotifier? myStateNotifier = mapAllDevicesSubStateNotifier[jsonMap['Name']];
  if (jsonMap['Device'] == null) {
    return;
  }

  countOtherMessages++;
//  WidgetMqttChangeNotifier? notifier2 = mapWidgetMqtt[jsonMap['Name']] as WidgetMqttChangeNotifier?;
  if (myStateNotifier != null) {
    // suppress uncessary key
    // add indication to the widget that it is to be used for widget setup ex barchart
    myStateNotifier.stateUpdateOtherJsonMap(jsonMap);
    emptyAssociatedNotifierFromBufferMqtt(jsonMap, myStateNotifier);
  } else {
    updateBufferMqtt(jsonMap);
  }
}

//!
//! special pour les capteurs sonoff envoyant les données en plusieurs json sur le meme topic
//! ne doit pas exister en final
bool checkSonoffTemperature(dynamic jsonObject) {
  if (jsonObject['Device'][0] != 't' || jsonObject['Device'][1] != 'h') return false;
  if (jsonObject.length < 7) return true;
  return false;
}

//**************************************************************************************/
//*             BUFFERING MQTT                                                         */
//**************************************************************************************/
int countBufferMqtt = 0;
List<Map<String, dynamic>> bufferMqtt = [];
//* lorsque le notifier n'est pas encore activé: ajoute au buffer ou update le buffer */
void updateBufferMqtt(Map<String, dynamic> json) {
  if (bufferMqtt.isEmpty) {
    // liste vide créer le prmier element avec le json recu
    bufferMqtt.add(json);
    countBufferMqtt++;
    return;
  }
  int i;
  for (i = 0; i < bufferMqtt.length; i++) {
    if (bufferMqtt[i]['Name'] == json['Name'] && bufferMqtt[i]['TYPE'] == json['TYPE']) {
      bufferMqtt[i] = json;
      return; //* existe donc est remplacé
    }
  }
  //* n'existe pas donc est ajouté a la liste
  bufferMqtt.add(json);
  countBufferMqtt++;
}

//* lorsque le notifier est activé: vide la liste pour future consommation */
void emptyAssociatedNotifierFromBufferMqtt(Map<String, dynamic> json, WidgetMqttStateNotifier myStateNotifier) {
  int i;
  //* supprime le prédent si il existe */
  for (i = 0; i < bufferMqtt.length; i++) {
    if (bufferMqtt[i]['Name'] == json['Name'] && bufferMqtt[i]['TYPE'] == json['TYPE']) {
      bufferMqtt.removeAt(i);
      countBufferMqtt--;
      //* un précedent existe donc est supprimé
    }
  }

  //*  consomme tous les précents associé a ce 'notifier'
  for (i = 0; i < bufferMqtt.length; i++) {
    if (bufferMqtt[i]['Name'] == json['Name']) {
      switch (bufferMqtt[i]['TYPE']) {
        case 'SENSOR':
          myStateNotifier.stateUpdateTeleJsonMap(bufferMqtt[i]);
          bufferMqtt.removeAt(i--);
          countBufferMqtt--;
          break;
        default:
          myStateNotifier.stateUpdateOtherJsonMap(bufferMqtt[i]);
          bufferMqtt.removeAt(i--);
          countBufferMqtt--;
          break;
      }
    }
  }
}

void emptyMqttBuffer(String deviceId, WidgetMqttStateNotifier myStateNotifier) {
  int i;
  //*  consomme tous les précents associé a ce 'notifier'
  for (i = 0; i < bufferMqtt.length; i++) {
    if (bufferMqtt[i]['Name'] == deviceId) {
      switch (bufferMqtt[i]['TYPE']) {
        case 'SENSOR':
          myStateNotifier.stateUpdateTeleJsonMap(bufferMqtt[i]);
          bufferMqtt.removeAt(i--);
          countBufferMqtt--;
          break;
        default:
          myStateNotifier.stateUpdateOtherJsonMap(bufferMqtt[i]);
          bufferMqtt.removeAt(i--);
          countBufferMqtt--;
          break;
      }
    }
  }
}
