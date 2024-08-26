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

  // appbar title
  static TextStyle pageHeadline = const TextStyle(
      color: blackColor,
      fontSize: 24.0,
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
      fontWeight: FontWeight.bold,
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
  static TextStyle cancelBtn = const TextStyle(
      color: primaryColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5
  );

  // edit button
  static TextStyle editBtn = const TextStyle(
      color: blackColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );

  // submit button
  static TextStyle submitBtn = const TextStyle(
      color: blackColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );

  // delete button
  static TextStyle deleteBtn = const TextStyle(
      color: redText,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5
  );

  // report button
  static TextStyle reportBtn = const TextStyle(
      color: redText,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5
  );

  // details on report window
  static TextStyle reportDetails = const TextStyle(
      color: blackColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );

  // drawing details at My Gallery
  static TextStyle drawingLabel = TextStyle(
      color: blackColor.withOpacity(0.7),
      fontSize: 16.0,
      fontFamily: 'Verdana',
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5
  );

  // username label for each InkGram post at homepage
  static TextStyle inkgramPostUser = const TextStyle(
      color: blackColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5
  );

  // description label for each InkGram post at homepage
  static TextStyle inkgramPostDesc = const TextStyle(
      color: blackColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );

  // username at comment
  static TextStyle inkgramCommentUser = const TextStyle(
      color: blackColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5
  );

  // comment
  static TextStyle inkgramComment = const TextStyle(
      color: blackColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );

  // reply button
  static TextStyle replyBtn = TextStyle(
      color: blackColor.withOpacity(0.5),
      fontSize: 12.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );

  // hint text
  static TextStyle hintTxt = TextStyle(
      color: blackColor.withOpacity(0.5),
      fontSize: 16.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );

  // text at drawer
  static TextStyle textName = const TextStyle(
    color: primaryColor,
    fontSize: 16.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  // logout text at drawer
  static TextStyle logoutTxt = const TextStyle(
      color: Colors.red,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5
  );

  // subtitle at login and register
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

  // textfield texts
  static TextStyle tfName = TextStyle(
    color: blackColor.withOpacity(0.5),
    fontSize: 16.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  // error at textfields texts
  static TextStyle tfError = const TextStyle(
      color: Colors.red,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5
  );

  // for any clickable text
  static TextStyle clickableTxt = const TextStyle(
    color: primaryColor,
    fontSize: 14.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  // forgot password text
  static TextStyle forgotPassword = const TextStyle(
    color: blackColor,
    fontSize: 20.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  // reset password text
  static TextStyle resetWithEmail = const TextStyle(
    color: blackColor,
    fontSize: 16.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  // headline at dashboard page
  static TextStyle dashboardHeadline = const TextStyle(
    color: blackColor,
    fontSize: 20.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  // bold text at dashboard page
  static TextStyle dashboardTxtBold = const TextStyle(
    color: blackColor,
    fontSize: 16.0,
    fontFamily: 'Verdana',
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5
  );

  // regular text at dashboard page
  static TextStyle dashboardTxt = const TextStyle(
    color: blackColor,
    fontSize: 16.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  // dashboard categories text
  static TextStyle dashboardCategories = const TextStyle(
    color: blackColor,
    fontSize: 14.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  // title for community and resource
  static TextStyle resourceTitle = const TextStyle(
    color: Colors.pinkAccent,
    fontSize: 14.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  // resource creator text
  static TextStyle resourceCreator = const TextStyle(
    color: blackColor,
    fontSize: 12.0,
    fontFamily: 'Verdana',
    letterSpacing: 1.5
  );

  // login/register button text
  static TextStyle loginBtn = const TextStyle(
      color: whiteColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );

  // sign in with google text
  static TextStyle googleBtn = const TextStyle(
      color: blackColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );

  // label for forum title post
  static TextStyle forumTitle = const TextStyle(
      color: blackColor,
      fontSize: 18.0,
      fontFamily: 'Verdana',
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5
  );

  // label for forum post
  static TextStyle forumLabel = const TextStyle(
      color: blackColor,
      fontSize: 16.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );

  // label for forum poster
  static TextStyle forumBy = TextStyle(
      color: blackColor.withOpacity(0.7),
      fontSize: 12.0,
      fontFamily: 'Verdana',
      letterSpacing: 1.5
  );
}

class DarkTextTheme {
  DarkTextTheme._();
}

