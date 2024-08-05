import 'package:InklusiveDraw/source/colors.dart';
import 'package:flutter/material.dart';

class LightTextTheme {
  LightTextTheme._();

  static TextStyle appName = const TextStyle(
    color: primaryColor,
    fontSize: 36.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  // label at homepage grid
  static TextStyle labelName = const TextStyle(
    color: whiteColor,
    fontSize: 16.0,
    fontFamily: 'Verdana',
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5
  );

  // edit profile label at profile screen
  static TextStyle editProfile = const TextStyle(
    color: whiteColor,
    fontSize: 16.0,
    fontFamily: 'Verdana',
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5
  );

  // label at profile screen
  static TextStyle profileTxt = const TextStyle(
      color: blackColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );

  // label at profile screen but bold
  static TextStyle profileTxtBold = const TextStyle(
      color: blackColor,
      fontSize: 20.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );

  // save button
  static TextStyle saveBtn = const TextStyle(
      color: whiteColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5
  );

  // cancel button
  static TextStyle cancelBtn = TextStyle(
      color: blackColor.withOpacity(0.5),
      fontSize: 16.0,
      fontFamily: 'Verdana',
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5
  );

  static TextStyle textName = const TextStyle(
    color: primaryColor,
    fontSize: 16.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle subName = const TextStyle(
    color: blackColor,
    fontSize: 24.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle regularTxt = const TextStyle(
    color: blackColor,
    fontSize: 16.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle tfName = const TextStyle(
    color: blackColor,
    fontSize: 16.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle clickableTxt = const TextStyle(
    color: primaryColor,
    fontSize: 14.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle forgetPassword = const TextStyle(
    color: blackColor,
    fontSize: 20.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle resetWithEmail = const TextStyle(
    color: blackColor,
    fontSize: 16.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle dashboardHeadline = const TextStyle(
    color: blackColor,
    fontSize: 24.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle dashboardTxtBold = const TextStyle(
    color: blackColor,
    fontSize: 16.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle dashboardTxt = const TextStyle(
    color: blackColor,
    fontSize: 16.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle dashboardCategories = const TextStyle(
    color: blackColor,
    fontSize: 10.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle profileHeadline = const TextStyle(
    color: blackColor,
    fontSize: 24.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle resourceTitle = const TextStyle(
    color: blackColor,
    fontSize: 14.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  static TextStyle resourceCreator = const TextStyle(
    color: blackColor,
    fontSize: 12.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );
}

class DarkTextTheme {
  DarkTextTheme._();
}

