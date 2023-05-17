import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_models/complex_state_fz.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../state_notifier.dart';

class RootClimatisationWidget extends ConsumerWidget {
  const RootClimatisationWidget({Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 100,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF24FF07), width: 5),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(60),
                topLeft: Radius.circular(60),
                bottomRight: Radius.circular(60 / 2),
                bottomLeft: Radius.circular(60 / 2),
              )),
          // gauge
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(MdiIcons.refreshAuto),
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(MdiIcons.fan),
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.ac_unit),
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(MdiIcons.radiator),
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(MdiIcons.water),
                  ),
                ],
              ),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: const <Widget>[
                      SleekCircularSlider(
                        initialValue: 20,
                        min: 16,
                        max: 31,
                      ),
                      // text temperature
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(MdiIcons.fan, size: 50),
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(MdiIcons.fan, size: 75),
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(MdiIcons.fan, size: 100),
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(MdiIcons.fan, size: 125),
                  ),
                ],
              )
            ],
          ),
        );
      },
      // containter frame
    );
  }
}
