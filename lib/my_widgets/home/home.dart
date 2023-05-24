import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../my_models/complex_state_fz.dart';
import '../sub_widgets/mini_dashboard_conso/dashboard_conso.dart';
import '../sub_widgets/prevision_meteo/meteo.dart';
import '../state_notifier.dart';
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                height: 140,
                child: SubGaugeExterieureWidget(
                  master: '',
                  stateProvider: listStateProviders[0],
                ),
              ),
              const Divider(thickness: 1),
              const SizedBox(
                height: 270,
                child: SubMeteoWidget(),
              ),
              const Divider(thickness: 1),
              SizedBox(
                height: 100,
                child: SubDashboardConsoWidget(master: '', stateProvider: listStateProviders[1]),
              ),
            ],
          ),
        );
      },
      // containter frame
    );
  }
}
