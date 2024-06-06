import 'package:flutter/material.dart';
import '../../../source/colors.dart';
import '../../../source/image_strings.dart';
import '../../../source/text_theme.dart';

class UserBanner extends StatelessWidget {
  const UserBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              // card
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: secondaryColor
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Image(
                            image: AssetImage(
                                onBoardImage1
                            ),
                          ),
                        ),
                        Flexible(
                          child: Image(
                            image: AssetImage(
                                onBoardImage2
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Test tes tes tes',
                      style: LightTextTheme.dashboardTxt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'That',
                      style: LightTextTheme.dashboardTxt,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              // card
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: secondaryColor
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Icon(Icons.bookmark)
                        ),
                        Flexible(
                          child: Image(
                            image: AssetImage(
                                onBoardImage2
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Test tes tes tes',
                      style: LightTextTheme.dashboardTxt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'That',
                      style: LightTextTheme.dashboardTxt,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {

                  },
                  child: Text(
                    'View more',
                    style: LightTextTheme.dashboardTxt,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
