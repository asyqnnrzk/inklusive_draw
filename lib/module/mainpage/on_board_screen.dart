import 'package:InklusiveDraw/module/mainpage/homepage.dart';
import 'package:InklusiveDraw/module/user_auth_and_profile/login/'
    'login_screen.dart';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class OnBoardScreen extends StatelessWidget {
  OnBoardScreen({super.key});

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: [
              Container(
                padding: const EdgeInsets.all(16),
                color: onBoardPageColor1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: const AssetImage(onBoardImage1),
                      height: size.height * 0.5,
                    ),
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontFamily: 'MontserratBold',
                        fontSize: 32,
                        color: primaryColor
                      ),
                    ),
                    const Text(
                      'Swipe to continue',
                      style: TextStyle(
                        fontFamily: 'MontserratRegular',
                        fontSize: 16,
                        color: primaryColor
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: onBoardPageColor2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Let's start!",
                      style: TextStyle(
                        fontFamily: 'MontserratBold',
                        fontSize: 32,
                        color: whiteColor
                      ),
                    ),
                    const Text(
                      'Swipe to continue',
                      style: TextStyle(
                        fontFamily: 'MontserratRegular',
                        fontSize: 16,
                        color: whiteColor
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const
                        LoginScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: whiteColor,
                        backgroundColor: secondaryColor
                      ),
                      child: const Text(
                        'Login',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const
                        Homepage()),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: whiteColor,
                        backgroundColor: secondaryColor
                      ),
                      child: const Text(
                        'Continue without login',
                      ),
                    ),
                    Image(
                      image: const AssetImage(onBoardImage2),
                      height: size.height * 0.5,
                    ),
                  ],
                ),
              ),
            ],
            slideIconWidget: const Icon(Icons.arrow_back_ios),
            enableSideReveal: true,
          ),
        ],
      ),
    );
  }
}
