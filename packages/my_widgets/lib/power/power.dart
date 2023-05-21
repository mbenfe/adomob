import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_models/complex_state_fz.dart';

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
class RootConsomationWidget extends ConsumerWidget {
  const RootConsomationWidget({Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
      : super(key: key);
  final String master;
  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;

  @override
  Widget build(BuildContext context, ref) {
    // final key = mapGlobalKeys[master];

    // var intermediate;
    // var intermediate2;
    // var keys;

    if (kDebugMode) {
      print('master:$master');
    }
    JsonForMqtt state;
    //* recoit l'etat qui contient le json telemetry et une list supplementaire de json
    //* pour l'affichages de cumuls heures, jours, mois
    if (listSlaves.isEmpty) {
      state = ref.watch(listStateProviders[0]); //* boitier réel 1 seul provider
    } else {
      state = ref.watch(listStateProviders[1]); //* boitier virtuel premier provider ne recoit rien, second est le maitre
      // intermediate = mapAllDevicesStateProvider[listSlaves[0]];
      // state = ref.watch(intermediate);
      // intermediate2 = mapAllDevicesSubStateNotifier[listSlaves[0]];
      // keys = mapGlobalKeys[listSlaves[0]];

      // if (state.teleJsonMap.isNotEmpty) {
      //   print('virtuel');
      // }
//      state = ref.watch(intermetiate2);
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
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFF0707), width: 2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              )),
          child: Column(
            children: [
              Text(
                location,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              WidgetGauge(jsonMap: teleJsonMap),
              WidgetPeriodicalCharts(heures: heures, jours: jours, mois: mois)
            ],
          ),
        );
      },
      // containter frame
    );
  }
}
