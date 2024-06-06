import 'package:flutter/material.dart';
import 'colors.dart';

class CircularProgressIndicatorTheme extends StatelessWidget {
  const CircularProgressIndicatorTheme({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        strokeWidth: 4,
        backgroundColor: Colors.grey,
      ),
    );
  }
}