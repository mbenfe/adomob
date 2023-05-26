import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../my_models/complex_state_fz.dart';
import '../../my_notifiers/settable_manager.dart';
import '../sub_widgets/mini_dashboard_conso/dashboard_conso.dart';
import '../sub_widgets/prevision_meteo/meteo.dart';
import '../../my_notifiers/widgets_manager.dart';
import '../sub_widgets/temperature_exterieur/gauge_exterieur.dart';

/// ConsumerWidget for riverpod
class RootHomeWidget extends ConsumerWidget {
  const RootHomeWidget({Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
      : super(key: key);
  final String master;
  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;

  @override
  Widget build(BuildContext context, ref) {
    //*  noditification de 'reglabilité' de la widget
    IsPageReglableNotifier reglableNotifier = ref.read(pageReglableProvider.notifier);
    Future.delayed(Duration.zero, () {
      reglableNotifier.setReglable(IsReglable(false));
    });

    return SizedBox(
      height: MediaQuery.of(context).size.height - // total height
          kToolbarHeight - // top AppBar height
          MediaQuery.of(context).padding.top - // top padding
          MediaQuery.of(context).padding.bottom -
          kBottomNavigationBarHeight, // BottomNavigationBar height
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Flexible(
            flex: 3,
            child: Card(
              //      shape: const CircleBorder(),
              child: CardGaugeExterieureWidget(
                master: '',
                stateProvider: listStateProviders[0],
              ),
            ),
          ),
          const Flexible(
            flex: 5,
            child: Card(
              child: SubMeteoWidget(),
            ),
          ),
          Flexible(
            flex: 2,
            child: Card(
              child: SubDashboardConsoWidget(master: '', stateProvider: listStateProviders[1]),
            ),
          ),
        ],
      ),
    );

    // containter frame
  }
}
