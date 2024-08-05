import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../source/colors.dart';
import '../../../source/text_theme.dart';

class ProfileMenuWidget extends StatefulWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.trailingIcon,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final IconData? trailingIcon;
  final Color? textColor;

  @override
  _ProfileMenuWidgetState createState() => _ProfileMenuWidgetState();
}

class _ProfileMenuWidgetState extends State<ProfileMenuWidget> {
  final FlutterTts _flutterTts = FlutterTts();

  void _speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = isDark ? primaryColor : secondaryColor;

    return ListTile(
      onTap: widget.onPress,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: primaryColor.withOpacity(0.1),
        ),
        child: Icon(
          widget.icon,
          color: primaryColor,
        ),
      ),
      title: Text(
        widget.title,
        style: LightTextTheme.profileTxt.apply(
          color: widget.textColor,
        ),
      ),
      trailing: widget.endIcon
          ? GestureDetector(
        onTap: () => _speak(widget.title),
        child: const Icon(
          Icons.volume_up,
          size: 20,
          color: primaryColor,
        ),
      )
          : null,
    );
  }
}
