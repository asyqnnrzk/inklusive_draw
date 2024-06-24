import 'package:InklusiveDraw/module/support_and_resources/community/'
    'community_screen.dart';
import 'package:InklusiveDraw/module/support_and_resources/favorites/'
    'favorite_screen.dart';
import 'package:InklusiveDraw/module/support_and_resources/resource/'
    'resource_screen.dart';
import 'package:flutter/material.dart';
import '../../../source/colors.dart';
import '../../../source/text_theme.dart';

class UserBanner extends StatelessWidget {
  UserBanner({super.key});

  final List<String> categories = [
    'Favorites',
    'Resources',
    'Community',
  ];

  final List<Icon> icons = [
    const Icon(Icons.favorite, color: whiteColor, size: 30),
    const Icon(Icons.list_alt, color: whiteColor, size: 30),
    const Icon(Icons.people, color: whiteColor, size: 30),
  ];

  final List<Widget> pages = [
    FavoriteScreen(),
    const ResourceScreen(),
    const CommunityScreen()
  ];

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
                  color: secondaryColor,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 90,
                      child: GridView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.1,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                pages[index]),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: icons[index],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  categories[index],
                                  style: LightTextTheme.dashboardCategories,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
