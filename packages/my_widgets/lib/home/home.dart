import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_adomob/m_main.dart';
import 'package:my_models/complex_state_fz.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../state_notifier.dart';

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
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: WebViewWidget(
                controller: webController1,
              ),
            ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width,
            //   height: 300,
            //   child: WebViewWidget(
            //     controller: webController2,
            //   ),
            // )
          ],
        );
      },
      // containter frame
    );
  }
}
