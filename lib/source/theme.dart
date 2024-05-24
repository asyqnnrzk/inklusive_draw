import 'package:InklusiveDraw/source/textfield_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._(); // private

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    inputDecorationTheme: TextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    inputDecorationTheme: TextFormFieldTheme.darkInputDecorationTheme
  );
}