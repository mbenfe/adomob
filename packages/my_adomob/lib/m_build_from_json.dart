// //* globales variables initialisées par mqtt
// //* STATE PROVIDER
// final Map<String, StateNotifierProvider<WidgetMqttStateNotifier, Map>> mapAllDevicesStateProvider = {};
// final Map<String, WidgetMqttStateNotifier> mapAllDevicesSubStateProvider = {};
// //* CHANGE PROVIDER
// final Map<String, ChangeNotifierProvider<WidgetMqttChangeNotifier>> mapAllDevicesChangeProvider = {};
// final Map<String, WidgetMqttChangeNotifier> mapAllDevicesSubChangeProvider = {};
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_models/adomob_app_cfg.dart';
import 'package:my_models/complex_state_fz.dart';
import 'package:my_widgets/state_notifier.dart';

//Map<String, List<Key>> mapGlobalKeys = {};
Map<String, List<GlobalKey<State<StatefulWidget>>>> mapGlobalKeys = {};

List<Bundle> listBundles = [];
List<String> listApplications = [];
//* globales variables initialisées par mqtt
dynamic mapDevices = {};
//List<String> listApplications = [];

//* globales variables
List<String> listDevices = [];

class Bundle {
  String type = "";
  String location = "";
  String master = "";
  List<String> listSlaves = [];
  int column = 0;
  int row = 0;
  List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders = [];
}

//*---------------------------------------------------------
//* initialisation des devices recu par mqtt json
//*---------------------------------------------------------
void analyseReceivedDevicesCfgJson(String jsonString) {
  mapDevices = json.decode(jsonString);
  mapDevices.forEach((k, v) => listDevices.add((k).toString()));
}

//*---------------------------------------------------------
//* initialisation des devices recu par mqtt json
//* deux etapes:
//*  1 - contruire la liste des bundles pour la mise en place de widgets: listBundle
//* 2 - constuire le mapping des notifiers pour chaque devices: mapAllDevices
//*---------------------------------------------------------
void analyseReceivedAppCfgJson2(String jsonString) {
  // 1 - construit la list des applications à parir de appCfg.json recu par mqtt
  if (kDebugMode) {
    print(jsonString);
  }

  int i, j, k;
  var jsonDecoded = (json.decode(jsonString) as List).cast<Map<String, dynamic>>();

  ListElementApp mapApplications;
  // * etape 1 :build la list des bundle pour chaque application sachant que seul chauffage application a un master et un/plusieurs slave(s)
  // * cela pourait evoluer dans le future
  // * cette liste est utilisée par le fonction appBuildSelectedView (m_mobile_aalication.dart)
  // * etape 2 : build la map des notifiers par device
  for (i = 0; i < jsonDecoded.length; i++) {
    mapApplications = ListElementApp.fromJson(jsonDecoded[i]);
    listApplications.add(mapApplications.type);
    for (j = 0; j < mapApplications.data.length; j++) {
      Bundle bundle = Bundle();
      //* construit la liste des keys pour les widgets ayant des escalves dont elles veules avoir accés aux donnéées
      //* example: Tableau electrique pricipale pour retrancher les donnees du tableau secondaire (baudin seignosse)

      GlobalKey<State<StatefulWidget>> newKey;
      if (mapApplications.data[j].master != "") {
//        bundle.widgetKey.add(GlobalKey(debugLabel: mapApplications.data[j].master));

        // si deja dans la map (declaré précédement comme master -> ajout des esclaves
        if (mapGlobalKeys.containsKey(mapApplications.data[j].master)) {
          for (int slave = 0; slave < mapApplications.data[j].slave.length; slave++) {
            newKey = GlobalKey(debugLabel: mapApplications.data[j].slave[slave]);
            mapGlobalKeys[mapApplications.data[j].master]?.add(newKey);
          }
        } else {
          newKey = GlobalKey(debugLabel: mapApplications.data[j].master);
          mapGlobalKeys.addAll({
            mapApplications.data[j].master: [newKey]
          });
        }
      }
      final StateProvider1 = getStateProvider(mapApplications.data[j].master);
      bundle.listStateProviders.add(StateProvider1);
      mapAllDevicesStateProvider.addAll({mapApplications.data[j].master: StateProvider1}); // master
      for (k = 0; k < mapApplications.data[j].slave.length; k++) {
        bundle.listSlaves.add(mapApplications.data[j].slave[k]);
        final StateProvider2 = getStateProvider(mapApplications.data[j].slave[k]);
        bundle.listStateProviders.add(StateProvider2);
        mapAllDevicesStateProvider.addAll({mapApplications.data[j].slave[k]: StateProvider2}); // slave
      }
      bundle.master = mapApplications.data[j].master;
      bundle.location = mapApplications.data[j].location;
      bundle.column = mapApplications.data[j].column;
      bundle.row = mapApplications.data[j].row;
      bundle.type = mapApplications.type;
      listBundles.add(bundle);
    }
  }
  if (kDebugMode) {
    print("ADOMOB: configuration received");
  }
}

StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt> getStateProvider(String deviceId) {
//  WidgetMqttStateNotifier a;
  final StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt> provider = StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>((ref) {
    final WidgetMqttStateNotifier notifier =
        WidgetMqttStateNotifier(JsonForMqtt(teleJsonMap: {}, listOtherJsonMap: [], listCmdJsonMap: [], deviceId: deviceId));
    mapAllDevicesSubStateNotifier.addAll({deviceId: notifier});
    return notifier;
  });
  return provider;
}
