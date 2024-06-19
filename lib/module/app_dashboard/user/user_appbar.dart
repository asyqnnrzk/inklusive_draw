import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../source/colors.dart';
import '../../../source/image_strings.dart';

class UserDashboardAppbar extends StatelessWidget implements PreferredSizeWidget {
  const UserDashboardAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(LineAwesomeIcons.angle_left_solid),
      ),
      title: const Text(
        'InklusiveDraw',
        style: TextStyle(
            fontFamily: 'MontserratBold',
            fontSize: 20,
            color: primaryColor
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: greyColor
          ),
          child: IconButton(
            onPressed: () {

            },
            icon: const Image(
              image: AssetImage(userDefault),
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}