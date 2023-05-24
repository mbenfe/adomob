// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorSchemeSeed: Colors.blue,
//  useMaterial3: true,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
//  colorScheme: const ColorScheme.dark(),
  colorSchemeSeed: Colors.white,
//  useMaterial3: true,
);
