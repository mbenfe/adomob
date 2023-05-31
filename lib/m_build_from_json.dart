import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'm_data.dart';
import 'my_models/adomob_app_cfg.dart';
import 'my_models/complex_state_fz.dart';
import 'my_notifiers/widgets_manager.dart';

//Map<String, List<Key>> mapGlobalKeys = {};
//Map<String, GlobalKey<State<StatefulWidget>>> mapGlobalKeys = {};

List<Bundle> listBundles = [];
List<String> listApplications = [];

class Bundle {
  String type = "";
  String location = "";
  String master = "";
  List<String> listSlaves = [];
  int column = 0;
  int row = 0;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders = [];
}

//*---------------------------------------------------------
//* initialisation des devices recu par mqtt json
//* deux etapes:
//*  1 - contruire la liste des bundles pour la mise en place de widgets: listBundle
//* 2 - constuire le mapping des notifiers pour chaque devices: mapAllDevices
//* 3 - initialise les données par default des applications ex:chauffage-> listPieces et mapChauffages
//*---------------------------------------------------------
void analyseReceivedAppCfgJson2(String jsonString) {
  // 1 - construit la list des applications à parir de appCfg.json recu par mqtt
  if (kDebugMode) {
    print(jsonString);
  }

  int i, j, k;
  var jsonDecoded = (json.decode(jsonString) as List).cast<Map<String, dynamic>>();

  ListElementApp mapApplications;
  //****************************************************/
  //* etape 1 : build la map des notifiers par device
  //****************************************************/
  for (i = 0; i < jsonDecoded.length; i++) {
    mapApplications = ListElementApp.fromJson(jsonDecoded[i]);
    listApplications.add(mapApplications.type);
    for (j = 0; j < mapApplications.data.length; j++) {
      //* device maitres
      final StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt> stateProvider1;
      if (!mapAllDevicesStateProvider.containsKey(mapApplications.data[j].master)) {
        stateProvider1 = getStateProvider(mapApplications.data[j].master);
        mapAllDevicesStateProvider.addAll({mapApplications.data[j].master: stateProvider1}); // master
      } //* devices esclaves
      for (k = 0; k < mapApplications.data[j].slave.length; k++) {
        final StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt> stateProvider2;
        if (!mapAllDevicesStateProvider.containsKey(mapApplications.data[j].slave[k])) {
          //* si n'existe pas dans la liste globale
          stateProvider2 = getStateProvider(mapApplications.data[j].slave[k]);
          mapAllDevicesStateProvider.addAll({mapApplications.data[j].slave[k]: stateProvider2}); // slave
        }
      }
    }
  }

  printHashCode();

  //****************************************************/
  // * etape 2 :build la list des bundle pour chaque application
  //*    exemple chauffage application a un master et un/plusieurs slave(s)
  // * cette liste est utilisée par le fonction appBuildSelectedView (m_mobile_aalication.dart)
  //****************************************************/
  for (i = 0; i < jsonDecoded.length; i++) {
    mapApplications = ListElementApp.fromJson(jsonDecoded[i]);
    for (j = 0; j < mapApplications.data.length; j++) {
      Bundle bundle = Bundle();
      //* construit la liste des keys pour les widgets ayant des escalves dont elles veules avoir accés aux donnéées
      //* example: Tableau electrique pricipale pour retrancher les donnees du tableau secondaire (baudin seignosse)

      // GlobalKey<State<StatefulWidget>> newKey = GlobalKey(debugLabel: mapApplications.data[j].master);
      // if (mapApplications.data[j].master != "") {
      //   mapGlobalKeys.addAll({mapApplications.data[j].master: newKey});
      // }
      final stateProvider1 = mapAllDevicesStateProvider[mapApplications.data[j].master];
      bundle.listStateProviders.add(stateProvider1!);
      for (k = 0; k < mapApplications.data[j].slave.length; k++) {
        bundle.listSlaves.add(mapApplications.data[j].slave[k]);
        final StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt> stateProvider2;
        stateProvider2 = mapAllDevicesStateProvider[mapApplications.data[j].slave[k]]!;
        bundle.listStateProviders.add(stateProvider2);
      }
      bundle.master = mapApplications.data[j].master;
      bundle.location = mapApplications.data[j].location;
      bundle.column = mapApplications.data[j].column;
      bundle.row = mapApplications.data[j].row;
      bundle.type = mapApplications.type;
      listBundles.add(bundle);
    }
  }

  //****************************************************/
  //* etape 3 : initialiseLes Données par defautl
  //****************************************************/
  for (i = 0; i < listApplications.length; i++) {
    initialiseDefaultData(listApplications[i]);
  }

  //* widget home par example
  finalizeVirtuelWidget();

  if (kDebugMode) {
    print("ADOMOB: configuration received");
  }
}

void printHashCode() {
  int i, j;
  if (kDebugMode) {
    print('------------- bundle -------------------');
  }
  for (i = 0; i < listBundles.length; i++) {
    for (j = 0; j < listBundles[i].listStateProviders.length; j++) {
      if (kDebugMode) {
        print('Master:${listBundles[i].master} ${listBundles[i].listStateProviders[j].hashCode}');
      }
    }
  }
  if (kDebugMode) {
    print('------------- liste -------------------');
  }
  mapAllDevicesStateProvider.forEach((key, value) {
    if (kDebugMode) {
      print('key:$key ${value.hashCode}');
    }
  });
}

void finalizeVirtuelWidget() {
  if (kDebugMode) {
    print("ADOMOB: analyze virtuels");
  }

  // cherche toute les esclaves qui sont des maitres
  int i, j, k;
  List<Bundle> listBundleVirtuel = [];

  //* construit la liste de Bundle Virtuel
  for (i = 0; i < listBundles.length; i++) {
    for (j = 0; j < listBundles[i].listSlaves.length; j++) {
      for (k = 0; k < listBundles.length; k++) {
        if (listBundles[k].master == listBundles[i].listSlaves[j]) {
          listBundleVirtuel.add(listBundles[i]);
          //* sort de la boucle pour ne pas ajouter plusieurs fois le meme bundle a la liste
          j = listBundles[i].listSlaves.length;
          break; // ajoute et passe au suivan
        }
      }
    }
  }

  //* reconstuit la liste des providers
  //* parcours la liste des bundles virtuels et efface la liste des providers
  //* pour la remplacer avec ceux des esclaves listés
  for (i = 0; i < listBundleVirtuel.length; i++) {
    for (j = 0; j < listBundles.length; j++) {
      if (listBundles[j].master == listBundleVirtuel[i].master) {
        listBundles[j].listStateProviders.clear();
        for (k = 0; k < listBundles[j].listSlaves.length; k++) {
          listBundles[j].listStateProviders.add(mapAllDevicesStateProvider[listBundles[j].listSlaves[k]]!);
        }
      }
    }
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
