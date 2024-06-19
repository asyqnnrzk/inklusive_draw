import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/textfield_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._(); // private

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    brightness: Brightness.light,
    inputDecorationTheme: TextFormFieldTheme.lightInputDecorationTheme,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor
    )
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    inputDecorationTheme: TextFormFieldTheme.darkInputDecorationTheme,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor
    )
  );
}