import 'package:flutter/material.dart';

class UserDashboardCategories {
  final String title;
  final String heading;
  final String subHeading;
  final VoidCallback? onPress;

  UserDashboardCategories(this.title, this.heading, this. subHeading, this.onPress);

  static List<UserDashboardCategories> list = [
    UserDashboardCategories('1', 'This', 'That', null),
    UserDashboardCategories('2', 'This', 'That', null),
    UserDashboardCategories('3', 'This', 'That', null),
    UserDashboardCategories('4', 'This', 'That', null),
  ];
}