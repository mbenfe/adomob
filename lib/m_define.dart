// -------------------- pre defined icon-text pour bottomNavigationBar -----------------------------
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppGroups {
  AppGroups(this.index, this.icon, this.text, this.flexFactor);
  final int index;
  final String text;
  final IconData icon;
  final int flexFactor;
}

List<AppGroups> preDefinedBottomNavigationBar = [
  AppGroups(0, MdiIcons.homeOutline, 'Home', 0),
  AppGroups(1, Icons.water, 'Arrosage', 0),
  AppGroups(2, Icons.door_sliding, 'Blinder', 0),
  AppGroups(3, Icons.login, 'Contact', 0),
  AppGroups(4, Icons.contactless, 'Extender', 0),
  AppGroups(5, Icons.light, 'Light', 0),
  AppGroups(6, MdiIcons.radiator, 'Chauffage', 15),
  AppGroups(7, Icons.swap_vert_sharp, 'State', 0),
  AppGroups(8, Icons.power_settings_new, 'Switch', 0),
  AppGroups(9, Icons.thermostat, 'Temperature', 0),
  // not from database/ json
  AppGroups(10, MdiIcons.homeThermometerOutline, 'Thermostat', 0),
  AppGroups(11, MdiIcons.lightningBoltOutline, 'Consommation', 10),
  AppGroups(12, MdiIcons.airConditioner, 'Climatisation', 0),
  AppGroups(13, Icons.settings, 'Setup', 0),
];

const int CONSOMATION_MODE_EUROS = 0;
const int CONSOMATION_MODE_KWH = 1;
double globalPrixHeuresPleines = 0.22;
double globalPrixHeuresCreuses = 0.17;

const double ROOM_WIDGET_SIZE = 180;
const double INSET_TEXT_TEMP = 15;
const double INSET_GAUGE = 10;
const double MIN_TEMP = 15;
const double MAX_TEMP = 25;

//* direction appli
//const String client = "benfeghoul";
//const String ville = "marcq-en-baroeul";

const String client = "bauduin";
const String ville = "seignosse";
