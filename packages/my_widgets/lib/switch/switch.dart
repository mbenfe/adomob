import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_models/complex_state_fz.dart';

import '../define.dart';
import '../state_notifier.dart';

/// ConsumerWidget for riverpod
class RootSwitchWidget extends ConsumerWidget {
  const RootSwitchWidget({Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
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
          width: ROOM_WIDGET_SIZE,
          height: ROOM_WIDGET_SIZE,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFF0707), width: 5),
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
              Positioned(top: 80, child: Text(location, style: const TextStyle(fontSize: 16))),
              Positioned(top: 100, right: 20, child: Text(jsonMap['Power'].toString(), style: const TextStyle(fontSize: 20))),
              Positioned(top: 100, left: 20, child: Text(jsonMap['LinkQuality'].toString(), style: const TextStyle(fontSize: 20))),
              Positioned(
                top: 20,
                child: IconButton(
                  color: jsonMap['Power'] ? Colors.amber : Colors.grey,
                  icon: const Icon(
                    Icons.power_settings_new,
                    size: 40,
                  ),
                  onPressed: () => {
                    // 2023 publish(decode, provider),
                  },
                ),
              ),
            ],
          ),
        );
      },
      // containter frame
    );
  }
}
