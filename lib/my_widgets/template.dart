import 'package:adomob/my_notifiers/widgets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../my_models/complex_state_fz.dart';

/// ConsumerWidget for riverpod
class RootTemplateWidget extends ConsumerWidget {
  const RootTemplateWidget({Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
      : super(key: key);
  final String master;
  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;

  @override
  Widget build(BuildContext context, ref) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return const Placeholder();
      },
      // containter frame
    );
  }
}
