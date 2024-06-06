import 'package:InklusiveDraw/source/image_strings.dart';
import 'package:flutter/material.dart';

class UserDashboardContent {
  final String title;
  final String image;
  final String heading;
  final String subHeading;
  final VoidCallback? onPress;

  UserDashboardContent(this.title, this.image, this.heading, this. subHeading, this.onPress);

  static List<UserDashboardContent> list = [
    UserDashboardContent('Drawings', onBoardImage1, 'untitled231', 'Time: 4.56', null),
    UserDashboardContent('Drawings', onBoardImage1, 'untitled231', 'Time: 4.56', null),
    UserDashboardContent('Drawings', onBoardImage1, 'untitled231', 'Time: 4.56', null),
  ];
}