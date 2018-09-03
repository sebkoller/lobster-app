import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.red[900],
    accentColor: Colors.red[500],
  );
}

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.red[500],
    accentColor: Colors.red[200],
  );
}