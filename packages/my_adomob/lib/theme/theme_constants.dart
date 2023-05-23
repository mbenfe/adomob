// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const LIGHT_PRIMARY_COLOR = Colors.deepOrange;
const DARK_PRIMARY_COLOR = Colors.amberAccent;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: LIGHT_PRIMARY_COLOR,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: DARK_PRIMARY_COLOR,
);
