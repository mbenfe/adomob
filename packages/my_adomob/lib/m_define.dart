// -------------------- pre defined icon-text pour appBar -----------------------------
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppGroups {
  final String text;
  final IconData icon;
  final int index;
  AppGroups(this.index, this.icon, this.text);
}

List<AppGroups> preDefinedAppBar = [
  AppGroups(0, MdiIcons.homeOutline, 'Home'),
  AppGroups(1, Icons.water, 'Arrosage'),
  AppGroups(2, Icons.door_sliding, 'Blinder'),
  AppGroups(3, Icons.login, 'Contact'),
  AppGroups(4, Icons.contactless, 'Extender'),
  AppGroups(5, Icons.light, 'Light'),
  AppGroups(6, MdiIcons.radiator, 'Chauffage'),
  AppGroups(7, Icons.swap_vert_sharp, 'State'),
  AppGroups(8, Icons.power_settings_new, 'Switch'),
  AppGroups(9, Icons.thermostat, 'Temperature'),
  // not from database/ json
  AppGroups(10, MdiIcons.homeThermometerOutline, 'Thermostat'),
  AppGroups(11, MdiIcons.lightningBoltOutline, 'Consommation'),
];
