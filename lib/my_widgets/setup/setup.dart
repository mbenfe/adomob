import 'package:adomob/my_widgets/setup/tarifs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../my_models/complex_state_fz.dart';
import '../../my_notifiers/widgets_manager.dart';
import 'heures_creuses_pleines.dart';

/// ConsumerWidget for riverpod
class RootSetupWidget extends ConsumerWidget {
  const RootSetupWidget({Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
      : super(key: key);

  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;
  final String master;

  @override
  Widget build(BuildContext context, ref) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(
              thickness: 10,
            ),
            const SizedBox(height: 10),
            const SetupHeuresCreusesPleines(),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: const GetTarifs(),
            ),
          ],
        );
      },
      // containter frame
    );
  }
}
