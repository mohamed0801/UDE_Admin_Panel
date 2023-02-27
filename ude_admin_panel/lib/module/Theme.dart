// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: constant_identifier_names
enum AppTheme { Dark, Light }

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    accentColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.white,
    bottomAppBarColor: Colors.grey[100],
    textTheme: TextTheme(headline1: TextStyle(color: Colors.grey[100])),
  ),
  AppTheme.Dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xff294c60),
    scaffoldBackgroundColor: Colors.grey[800],
    bottomAppBarColor: Colors.grey[700],
    textTheme: const TextTheme(headline1: TextStyle(color: Colors.white70)),
    accentColor: Colors.lightBlueAccent,
  )
};
