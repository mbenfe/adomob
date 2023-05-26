// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../my_models/complex_state_fz.dart';

final Map<String, StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> mapAllDevicesStateProvider = {};
final Map<String, WidgetMqttStateNotifier> mapAllDevicesSubStateNotifier = {};

class WidgetMqttStateNotifier extends StateNotifier<JsonForMqtt> {
  WidgetMqttStateNotifier(JsonForMqtt state) : super(state);

  void stateUpdateOtherJsonMap(Map<String, dynamic> newJsonMap) {
    List<Map<String, dynamic>> intermediate = state.listOtherJsonMap;

    if (intermediate.isEmpty) {
      intermediate.add(newJsonMap);
    } else {
      Map exist = intermediate.firstWhere((element) => element['TYPE'] == newJsonMap['TYPE'], orElse: () => {}); // return empty MAP if doesn't exist
      if (exist.isNotEmpty) {
        // trouvé -> replace
        intermediate.removeWhere((element) => element['TYPE'] == newJsonMap['TYPE']);
        intermediate.add(newJsonMap);
      } else {
        // ajout à la list
        intermediate.add(newJsonMap);
      }
    }
    state = state.copyWith(listOtherJsonMap: intermediate);

    //   state.classUpdateListOtherJson(newJsonMap);
  }

  void stateUpdateTeleJsonMap(Map<String, dynamic> newJsonMap) {
    Map<String, dynamic> intermediate = state.teleJsonMap;
    newJsonMap.forEach((keyNewJson, valueNewJson) {
      intermediate.update(keyNewJson, (value) {
        return newJsonMap[keyNewJson]; // + newJsonMap[valueNewJson];
      }, ifAbsent: () => newJsonMap[keyNewJson]);
      return;
    });

    state = state.copyWith(teleJsonMap: intermediate);
    //state.updateTeleJsonMap(newJsonMap);
  }
}
