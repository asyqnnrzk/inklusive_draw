import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/textfield_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._(); // private

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    brightness: Brightness.light,
    inputDecorationTheme: TextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    inputDecorationTheme: TextFormFieldTheme.darkInputDecorationTheme
  );
}