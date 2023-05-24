import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../my_models/complex_state_fz.dart';
import '../state_notifier.dart';
import 'periodical_barchart.dart';
import 'gauge.dart';

//********************************************************************************/
//*  le widget power est soir 'reel' soit 'virtuel'                              */
//*  reel: un maitre pas d'esclaves: traitement normal a partir du mqtt json     */
//*  virtuel: un maitre et des esclaves                                          */
//*           le maitre ne recoit jamais de mqtt json                            */
//*           le premier esclaves et un maitre: donc on ecoute les messages mqtt */
//*           les esclaves suivant sont a soustraire au maitre pour l'affichage  */
//*           exemple bauduin: virtuel soustrait les mesures du spa au mesure du */
//*           boitier principal, ce aui donne la mesure de la maison + piscine   */
//********************************************************************************/
/// ConsumerWidget for riverpod

class RootConsomationWidgetMaitre extends ConsumerWidget {
  const RootConsomationWidgetMaitre(
      {Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
      : super(key: key);
  final String master;
  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;

  @override
  Widget build(BuildContext context, ref) {
    JsonForMqtt state = JsonForMqtt(deviceId: "", teleJsonMap: {}, listOtherJsonMap: [], listCmdJsonMap: []);
    //* recoit l'etat qui contient le json telemetry et une list supplementaire de json
    //* pour l'affichages de cumuls heures, jours, mois

    if (listSlaves.isEmpty) {
      state = ref.watch(listStateProviders[0]); //* boitier réel 1 seul provider
    } else {
      //* boitier virtuel premier provider ne recoit rien, second est le maitre
      state = ref.watch(listStateProviders[1]); //* boitier virtuel premier provider ne recoit rien, second est le maitre
    }
    //* la telemetry est traitée directment dans la widgets avec test null-safety
    Map<String, dynamic> teleJsonMap = state.teleJsonMap;

    List<Map<String, dynamic>> listJsonMap = state.listOtherJsonMap;
    final Map<String, double> heures = {};
    final Map<String, double> jours = {};
    final Map<String, double> mois = {};

    //* l'affichage des cumuls se fait si ils existent
    if (listJsonMap.isNotEmpty) {
      int index;
      for (index = 0; index < listJsonMap.length; index++) {
        if (listJsonMap[index]['TYPE'] == 'PWHOURS') {
          listJsonMap[index]['DATA'].forEach((key, value) => heures[key] = value.toDouble());
        }
        if (listJsonMap[index]['TYPE'] == 'PWDAYS') {
          listJsonMap[index]['DATA'].forEach((key, value) => jours[key] = value.toDouble());
        }
        if (listJsonMap[index]['TYPE'] == 'PWMONTHS') {
          listJsonMap[index]['DATA'].forEach((key, value) => mois[key] = value.toDouble());
        }
      }
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          alignment: Alignment.topCenter,
          //        height: POWER_VERTICAL_WIDGET_SIZE,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text(
                location,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              WidgetGauge(jsonMap: teleJsonMap),
              WidgetPeriodicalCharts(heures: heures, jours: jours, mois: mois),
              const Divider(),
            ],
          ),
        );
      },
      // containter frame
    );
  }
}

class RootConsomationWidgetVirtuel extends ConsumerWidget {
  const RootConsomationWidgetVirtuel(
      {Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
      : super(key: key);
  final String master;
  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;

  @override
  Widget build(BuildContext context, ref) {
    final JsonForMqtt stateMaster;
    final List<JsonForMqtt> listStateSlaves = [];
    //* recoit l'etat qui contient le json telemetry et une list supplementaire de json
    //* pour l'affichages de cumuls heures, jours, mois

    //* boitier compteur Maitre
    stateMaster = ref.watch(listStateProviders[0]); //* boitier réel 1 seul provider
    for (int i = 0; i < listSlaves.length - 1; i++) {
      listStateSlaves.add(ref.watch(listStateProviders[1 + i])); //* boitier virtuel premier provider ne recoit rien, second est le maitre
    }
    //* 1 - traitement de la mesure principale cadran watts
    Map<String, dynamic> teleJsonMap = {};

    if (stateMaster.teleJsonMap.isNotEmpty) {
      teleJsonMap.addAll(stateMaster.teleJsonMap);
      //      stateMaster.copyTeleJsonTo(teleJsonMap);
      for (int i = 0; i < listStateSlaves.length; i++) {
        if (listStateSlaves[i].teleJsonMap.isNotEmpty) {
          teleJsonMap['ActivePower'] -= listStateSlaves[i].teleJsonMap['ActivePower'];
        }
      }
      if (kDebugMode) {
        print(
            'Garage:${stateMaster.teleJsonMap['ActivePower']} Bureau:${listStateSlaves[0].teleJsonMap['ActivePower']} Virtuel:${teleJsonMap['ActivePower']}');
      }
    }

    //* 2 traitement OtherJsonMap boitier maitre PWHOURS/PWWDAYS/PWMONTHS
    List<Map<String, dynamic>> listOtherJsonMap = []; //* compteur principal/maitre
    listOtherJsonMap.addAll(stateMaster.listOtherJsonMap);
    List<List<Map<String, dynamic>>> listSlavesOtherJsonMap = [];
    for (int i = 0; i < listStateSlaves.length; i++) {
      listSlavesOtherJsonMap.add(listStateSlaves[i].listOtherJsonMap); //* compteur principal/maitre
    }

    final Map<String, double> heures = {};
    final Map<String, double> jours = {};
    final Map<String, double> mois = {};
    Map<String, double> heuresSoustraction = {
      "0": 0,
      "1": 0,
      "2": 0,
      "3": 0,
      "4": 0,
      "5": 0,
      "6": 0,
      "7": 0,
      "8": 0,
      "9": 0,
      "10": 0,
      "11": 0,
      "12": 0,
      "13": 0,
      "14": 0,
      "15": 0,
      "16": 0,
      "17": 0,
      "18": 0,
      "19": 0,
      "20": 0,
      "21": 0,
      "22": 0,
      "23": 0
    };
    Map<String, double> joursSoustraction = {"Lun": 0, "Mar": 0, "Mer": 0, "Jeu": 0, "Ven": 0, "Sam": 0, "Dim": 0};
    Map<String, double> moisSoustraction = {
      "Jan": 0,
      "Fev": 0,
      "Mars": 0,
      "Avr": 0,
      "Mai": 0,
      "Juin": 0,
      "Juil": 0,
      "Aout": 0,
      "Sept": 0,
      "Oct": 0,
      "Nov": 0,
      "Dec": 0
    };

    //* l'affichage des cumuls se fait si ils existent
    if (listOtherJsonMap.isNotEmpty) {
      int index;
      for (index = 0; index < listOtherJsonMap.length; index++) {
        //**************************************PWHOURS */
        if (listOtherJsonMap[index]['TYPE'] == 'PWHOURS') {
          //* base compteur principal/maitre
          for (int i = 0; i < listStateSlaves.length; i++) {
            if (listSlavesOtherJsonMap.isNotEmpty && listSlavesOtherJsonMap[i].isNotEmpty) {
              listSlavesOtherJsonMap[i][index]['DATA'].forEach((key, value) {
                if (heuresSoustraction[key] == null) {
                  if (kDebugMode) {
                    print('json->${listSlavesOtherJsonMap[i][index]['DATA']}');
                  }
                }
                heuresSoustraction.addAll({key: heuresSoustraction[key]! + value.toDouble()});
              });
            }
          }
          listOtherJsonMap[index]['DATA'].forEach((key, value) => heures[key] = value.toDouble() - heuresSoustraction[key]);
        }
        //**************************************PWDAYS */
        if (listOtherJsonMap[index]['TYPE'] == 'PWDAYS') {
          for (int i = 0; i < listStateSlaves.length; i++) {
            if (listSlavesOtherJsonMap.isNotEmpty && listSlavesOtherJsonMap[i].isNotEmpty) {
              listSlavesOtherJsonMap[i][index]['DATA'].forEach((key, value) {
                if (joursSoustraction[key] == null) {
                  if (kDebugMode) {
                    print('json->${listSlavesOtherJsonMap[i][index]['DATA']}');
                  }
                }
                joursSoustraction.addAll({key: joursSoustraction[key]! + value.toDouble()});
              });
            }
          }
          listOtherJsonMap[index]['DATA'].forEach((key, value) => jours[key] = value.toDouble() - joursSoustraction[key]);
        }
        //**************************************PWMONTHS */
        if (listOtherJsonMap[index]['TYPE'] == 'PWMONTHS') {
          for (int i = 0; i < listStateSlaves.length; i++) {
            if (listSlavesOtherJsonMap.isNotEmpty && listSlavesOtherJsonMap[i].isNotEmpty) {
              listSlavesOtherJsonMap[i][index]['DATA'].forEach((key, value) {
                if (moisSoustraction[key] == null) {
                  if (kDebugMode) {
                    print('json->${listSlavesOtherJsonMap[i][index]['DATA']}');
                  }
                }
                if (moisSoustraction[key] != null) {
                  moisSoustraction.addAll({key: moisSoustraction[key]! + value.toDouble()});
                }
              });
            }
          }
          listOtherJsonMap[index]['DATA'].forEach((key, value) => mois[key] = value.toDouble() - moisSoustraction[key]);
        }
      }
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          alignment: Alignment.topCenter,
          //        height: POWER_VERTICAL_WIDGET_SIZE,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text(
                location,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              WidgetGauge(jsonMap: teleJsonMap),
              WidgetPeriodicalCharts(heures: heures, jours: jours, mois: mois),
              const Divider(),
            ],
          ),
        );
      },
      // containter frame
    );
  }
}
