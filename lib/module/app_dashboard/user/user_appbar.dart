import 'package:flutter/material.dart';
import '../../../source/colors.dart';
import '../../../source/image_strings.dart';

class UserDashboardAppbar extends StatelessWidget implements PreferredSizeWidget {
  const UserDashboardAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.menu),
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