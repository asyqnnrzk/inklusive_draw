import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../source/colors.dart';
import '../../../source/text_theme.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = isDark ? primaryColor : secondaryColor;

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: iconColor.withOpacity(0.1)
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: LightTextTheme.profileTxt.apply(
            color: textColor
        ),
      ),
      trailing: endIcon? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: greyColor
        ),
        child: const Icon(
          LineAwesomeIcons.angle_right_solid,
          size: 18,
          color: Colors.grey,
        ),
      ) : null,
    );
  }
}