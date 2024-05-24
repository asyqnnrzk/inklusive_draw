import 'package:InklusiveDraw/source/colors.dart';
import 'package:flutter/material.dart';

class TextFormFieldTheme {
  TextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
        border: OutlineInputBorder(),
        prefixIconColor: primaryColor,
        suffixIconColor: primaryColor,
        floatingLabelStyle: TextStyle(color: primaryColor),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: primaryColor
          )
        )
      );

  static InputDecorationTheme darkInputDecorationTheme =
  const InputDecorationTheme(
      border: OutlineInputBorder(),
      prefixIconColor: whiteColor,
      floatingLabelStyle: TextStyle(color: whiteColor),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 2,
              color: whiteColor
          )
      )
  );
}