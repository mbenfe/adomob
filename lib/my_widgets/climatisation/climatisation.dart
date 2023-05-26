// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adomob/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../my_models/complex_state_fz.dart';
import '../../my_notifiers/settable_manager.dart';
import '../../my_notifiers/widgets_manager.dart';
import 'commande.dart';

bool isOn = false;
List<bool> fanSpeed = [false, true, false, false, false];
List<bool> modeSelected = [false, false, true, false];
double temperature = 16;

class RootClimatisationWidget extends ConsumerWidget {
  const RootClimatisationWidget({Key? key, required this.master, required this.listSlaves, required this.location, required this.listStateProviders})
      : super(key: key);

  final List<String> listSlaves;
  final List<StateNotifierProvider<WidgetMqttStateNotifier, JsonForMqtt>> listStateProviders;
  final String location;
  final String master;

  @override
  Widget build(BuildContext context, ref) {
    //*  noditification de 'reglabilité' de la widget
    IsPageReglableNotifier reglableNotifier = ref.read(pageReglableProvider.notifier);
    Future.delayed(Duration.zero, () {
      reglableNotifier.setReglable(IsReglable(true));
    });

    int index;

    Map<String, JsonForMqtt> mapState = {};

    for (index = 0; index < listStateProviders.length; index++) {
      JsonForMqtt intermediate = ref.watch(listStateProviders[index]);
      mapState.addAll({intermediate.deviceId: intermediate});
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Header(location: location, listSlaves: listSlaves),
                ],
              ),
              SelectionMode(listSlaves: listSlaves),
              SelectionTemperature(listSlaves: listSlaves),
              SelectionFan(listSlaves: listSlaves),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
      // containter frame
    );
  }
}

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.location,
    required this.listSlaves,
  }) : super(key: key);

  final List<String> listSlaves;
  final String location;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(widget.location),
        const Text('10'),
        Switch(
          value: isOn,
          onChanged: (value) {
            setState(() {
              isOn = value;
              commande(isOn, fanSpeed, modeSelected, temperature, widget.listSlaves);
            });
          },
        ),
      ]),
    );
  }
}

class SelectionTemperature extends StatefulWidget {
  const SelectionTemperature({
    required this.listSlaves,
    super.key,
  });

  final List<String> listSlaves;

  @override
  State<SelectionTemperature> createState() => _SelectionTemperatureState();
}

class _SelectionTemperatureState extends State<SelectionTemperature> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SleekCircularSlider(
          appearance: CircularSliderAppearance(
            angleRange: 270,
            startAngle: 135,
            customColors: CustomSliderColors(
              dynamicGradient: false,
              progressBarColors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor],
              trackColor: Theme.of(context).disabledColor,
            ),
          ),
          initialValue: temperature,
          min: 16,
          max: 31,
          onChange: (double value) {
            // callback providing a value while its being changed (with a pan gesture)
          },
          onChangeStart: (double startValue) {
            // callback providing a starting value (when a pan gesture starts)
          },
          onChangeEnd: (double endValue) {
            setState(() {
              temperature = endValue;
              commande(isOn, fanSpeed, modeSelected, temperature, widget.listSlaves);
            });
            // callback providing an ending value (when a pan gesture ends)
          },
          innerWidget: (double value) {
            //This the widget that will show current value
            return Center(
                child: Text(
              "${value.toInt().toString()} °C",
              style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.w200),
            ));
          },
        ),
      ),
    );
  }
}

class SelectionMode extends StatefulWidget {
  const SelectionMode({
    required this.listSlaves,
    super.key,
  });

  final List<String> listSlaves;

  @override
  State<SelectionMode> createState() => _SelectionModeState();
}

class _SelectionModeState extends State<SelectionMode> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text('Mode:'),
        addHorizontalSpace(10),
        ToggleButtons(
          borderRadius: BorderRadius.zero,
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < modeSelected.length; i++) {
                modeSelected[i] = i == index;
              }
              commande(isOn, fanSpeed, modeSelected, temperature, widget.listSlaves);
            });
          },
          isSelected: modeSelected,
          children: const [
            Icon(MdiIcons.refreshAuto),
            Icon(MdiIcons.radiator),
            Icon(MdiIcons.water),
            Icon(Icons.ac_unit),
          ],
        ),
      ],
    );
  }
}

class SelectionFan extends StatefulWidget {
  const SelectionFan({
    required this.listSlaves,
    super.key,
  });

  final List<String> listSlaves;

  @override
  State<SelectionFan> createState() => _SelectionFanState();
}

class _SelectionFanState extends State<SelectionFan> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Ventilation:'),
          addHorizontalSpace(10),
          ToggleButtons(
            borderRadius: BorderRadius.zero,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < fanSpeed.length; i++) {
                  fanSpeed[i] = i == index;
                }
                commande(isOn, fanSpeed, modeSelected, temperature, widget.listSlaves);
              });
            },
            isSelected: fanSpeed,
            children: const [
              SizedBox(height: 50, width: 50, child: Icon(MdiIcons.refreshAuto, size: 30)),
              SizedBox(height: 50, width: 50, child: Icon(MdiIcons.fan, size: 20)),
              SizedBox(height: 50, width: 50, child: Icon(MdiIcons.fan, size: 30)),
              SizedBox(height: 50, width: 50, child: Icon(MdiIcons.fan, size: 40)),
              SizedBox(height: 50, width: 50, child: Icon(MdiIcons.fan, size: 50)),
            ],
          ),
        ],
      ),
    );
  }
}
