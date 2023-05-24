import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../my_models/complex_state_fz.dart';
import '../../state_notifier.dart';

/// ConsumerWidget for riverpod
class SubDashboardConsoWidget extends ConsumerWidget {
  const SubDashboardConsoWidget({
    Key? key,
    required this.master,
    required this.stateProvider,
  }) // required this.stateProvider})
  : super(key: key);
  final String master;
  final StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt> stateProvider;

  @override
  Widget build(BuildContext context, ref) {
    final JsonForMqtt state;
    Map<String, dynamic> teleJsonMap = {};
    state = ref.watch(stateProvider); //* power meter
    teleJsonMap = state.teleJsonMap;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Flexible(child: Text(teleJsonMap['ActivePower'] != null ? teleJsonMap['ActivePower'].toString() : ''))],
    );
  }
}
