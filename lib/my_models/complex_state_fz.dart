import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../m_define.dart';
import '../my_mqtt/mqtt_handler.dart';

part 'complex_state_fz.freezed.dart';

// @freezed
// class ComplexState with _$ComplexState {
//   const ComplexState._();

//   const factory ComplexState({
//     required String var1,
//     required double var2,
//     required bool var3,
//     required int var4,
//   }) = _ComplexState;
// }

@unfreezed
class JsonForMqtt with _$JsonForMqtt {
  JsonForMqtt._();

  factory JsonForMqtt({
    required String deviceId,
    required Map<String, dynamic> teleJsonMap,
    required List<Map<String, dynamic>> listOtherJsonMap,
    required List<Map<String, dynamic>> listCmdJsonMap,
  }) = _JsonForMqtt;

  //* commande allumage chauffage (mode manuel)
  void classSwitchToggle() {
    String topic = "gw/$client/$ville/cmnd/GW/ZbSend";
    String payload = '{"Device":"$deviceId","send":{"Power":"Toggle"}}';
    publishMqtt(topic, payload);
  }

  //* envoi du setup thermostat: away, semaine, week-end
  void classSendThermostat(String targetDevice, String period, Map<String, dynamic> tab) {
    String topic = "gw/$client/$ville/$targetDevice/tele/$period";
    String payload = tab.toString();
    payload = jsonEncode(tab);
    publishMqtt(topic, payload);
  }

  void classUpdateListOtherJson(Map<String, dynamic> newJsonMap) {
    if (listOtherJsonMap.isEmpty) {
      listOtherJsonMap.add(newJsonMap);
    } else {
      Map exist =
          listOtherJsonMap.firstWhere((element) => element['TYPE'] == newJsonMap['TYPE'], orElse: () => {}); // return empty MAP if doesn't exist
      if (exist.isNotEmpty) {
        // trouvé -> replace
        listOtherJsonMap.removeWhere((element) => element['TYPE'] == newJsonMap['TYPE']);
        listOtherJsonMap.add(newJsonMap);
      } else {
        // ajout à la list
        listOtherJsonMap.add(newJsonMap);
      }
    }
  }

  void classUpdateTeleJsonMap(Map newJsonMap) {
    newJsonMap.forEach((keyNewJson, valueNewJson) {
      teleJsonMap.update(keyNewJson, (value) {
        return newJsonMap[keyNewJson]; // + newJsonMap[valueNewJson];
      }, ifAbsent: () => newJsonMap[keyNewJson]);
      return;
    });
  }

  void copyTeleJsonTo(Map<String, dynamic> newJsonMap) {
    teleJsonMap.forEach((key, value) {
      newJsonMap[key] = value;
    });
  }
}

//* class json message setup away parameters
@freezed
class ThermostatAway with _$ThermostatAway {
  factory ThermostatAway({
    required int temperature,
    required int humidity,
    String? name,
  }) = _ThermostatAway;

//  factory ThermostatAway.fromJson(Map<String, dynamic> json) => _$ThermostatAwayFromJson(json);
//  Map<String, dynamic> toJson() => _$ThermostatAwayToJson(this);
}

// command: flutter pub run build_runner build --delete-conflicting-outputs