import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../my_models/complex_state_fz.dart';
import '../../my_notifiers/widgets_manager.dart';
import '../../m_define.dart';

class RootArrosageWidget extends ConsumerWidget {
  const RootArrosageWidget({Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
      : super(key: key);
  final String master;
  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;

  @override
  Widget build(BuildContext context, ref) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: ROOM_WIDGET_SIZE * 2,
          height: ROOM_WIDGET_SIZE,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF24FF07), width: 5),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(60),
                topLeft: Radius.circular(60),
                bottomRight: Radius.circular(60 / 2),
                bottomLeft: Radius.circular(60 / 2),
              )),
          // gauge
          child: Stack(
            alignment: Alignment.center,
            children: const <Widget>[
              Text('Arrosage', style: TextStyle(fontSize: 20)),
              // text temperature
            ],
          ),
        );
      },
      // containter frame
    );
  }
}
