import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../m_define.dart';
import '../../my_models/complex_state_fz.dart';

import '../../my_notifiers/widgets_manager.dart';

/// ConsumerWidget for riverpod
class RootLightWidget extends ConsumerWidget {
  const RootLightWidget({Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
      : super(key: key);
  final String master;
  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;

  @override
  Widget build(BuildContext context, ref) {
    final provider = ref.watch(listStateProviders[0]);
    Map jsonMap = {};
    jsonMap = provider.teleJsonMap;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: ROOM_WIDGET_SIZE * 2,
          height: ROOM_WIDGET_SIZE,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFBFF07), width: 5),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(60),
                topLeft: Radius.circular(60),
                bottomRight: Radius.circular(60 / 2),
                bottomLeft: Radius.circular(60 / 2),
              )),
          // gauge
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(top: 60, child: Text(location, style: const TextStyle(fontSize: 20))),
              Positioned(top: 80, child: Text(jsonMap['Status'].toString(), style: const TextStyle(fontSize: 20))), // bug a venir
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  color: jsonMap['Power'] ? Colors.amber : Colors.grey,
                  icon: const Icon(
                    Icons.lightbulb,
                    size: 40,
                  ),
                  onPressed: () {},
                ),
                //  onPressed:, // 20203
              ),
              // text temperature
            ],
          ),
        );
      },
      // containter frame
    );
  }
}
