import 'package:flutter/material.dart';

ThemeData lightThemeData() {
  return ThemeData(
    //fontFamily: 'IranSBold',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.purpleAccent,
    disabledColor: Colors.purpleAccent.shade100,
    textTheme: const TextTheme(
      caption: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    ),
  );
}
