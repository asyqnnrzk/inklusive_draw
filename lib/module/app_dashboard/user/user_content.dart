import 'dart:io';
import 'package:InklusiveDraw/module/inkgram/inkgram_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../source/colors.dart';
import '../../../source/text_theme.dart';
import '../../../model/user/user_content_model.dart';

class UserContent extends StatelessWidget {
  final List<UserDashboardContent> recentDrawings;

  const UserContent({super.key, required this.recentDrawings});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent activities',
          style: LightTextTheme.dashboardHeadline,
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: recentDrawings.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final content = recentDrawings[index];
              return GestureDetector(
                onTap: content.onPress,
                child: SizedBox(
                  width: 200,
                  height: 25,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondaryColor,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: content.imagePath.isNotEmpty
                                ? Image.file(
                              File(content.imagePath),
                              fit: BoxFit.cover,
                            )
                                : const Icon(Icons.image, size: 80),
                          ),
                          Text(
                            content.title,
                            style: LightTextTheme.dashboardTxt,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32.0),
        SizedBox(
          child: Column(
            children: [
              Text(
                "Feeling like posting something? Let's go to ",
                style: LightTextTheme.dashboardTxt,
              ),
              GestureDetector(
                child: Text(
                  "InkGram!",
                  style: LightTextTheme.appName,
                ),
                onTap: (){
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  if (userId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InkgramProfile(userId: userId),
                      ),
                    );
                  }
                }
              ),
            ],
          ),
        )
      ],
    );
  }
}
