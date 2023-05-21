import 'package:flutter/material.dart';
import 'package:my_adomob/m_define.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SelectionLightDark extends StatefulWidget {
  const SelectionLightDark({super.key});

  @override
  State<SelectionLightDark> createState() => _SelectionLightDarkState();
}

class _SelectionLightDarkState extends State<SelectionLightDark> {
  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      borderWidth: 1,
      activeBorders: [Border.all(color: Colors.green)],
      inactiveBgColor: Colors.white,
      activeBgColor: const [Colors.blue],
      customIcons: [
        Icon(
          Icons.light_mode,
          color: globalTheme == GLOBAL_THEME_LIGHT ? Colors.amber : Colors.grey,
        ),
        Icon(
          Icons.dark_mode,
          color: globalTheme == GLOBAL_THEME_LIGHT ? Colors.grey : Colors.black,
        )
      ],
      totalSwitches: 2,
      initialLabelIndex: globalTheme,
      onToggle: (value) {
        setState(() {
          globalTheme = value!;
        });
      },
    );
  }
}
