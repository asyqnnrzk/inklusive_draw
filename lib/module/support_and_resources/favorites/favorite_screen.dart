import 'dart:math';
import 'package:InklusiveDraw/module/support_and_resources/community/'
    'community_screen.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../source/text_theme.dart';
import '../resource/video_player_screen.dart';

class FavoriteScreen extends StatelessWidget {
  Future<void> _confirmDelete(BuildContext context, String userId,
      String favoriteId) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove Favorite?',
            style: LightTextTheme.reportDetails,
          ),
          content: Text(
            'Remove this from your favorite?',
            style: LightTextTheme.reportDetails,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: LightTextTheme.cancelBtn,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Remove',
                style: LightTextTheme.deleteBtn,
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(favoriteId)
          .delete();
    }
  }

  final List<Color> _pastelColors = [
    const Color(0xFFE5B9E2), // Light pastel purple
    const Color(0xFFB9E5B9), // Light pastel green
    const Color(0xFFB9E2F5), // Light pastel blue
    const Color(0xFFFFE5B9), // Light pastel beige
    const Color(0xFFB9E5E0), // Light pastel mint
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final random = Random();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: LightTextTheme.pageHeadline,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicatorTheme());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No favorites yet',
                    style: LightTextTheme.dashboardTxtBold,
                  ),
                  Text(
                    'Start adding some!',
                    style: LightTextTheme.dashboardTxtBold,
                  ),
                ],
              ));
          }

          final favorites = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              final data = favorite.data() as Map<String, dynamic>?;

              if (data == null || !data.containsKey('type')) {
                // If the type field does not exist, skip this document.
                return Container();
              }

              final type = data['type'];
              final color = _pastelColors[random.nextInt(_pastelColors.length)];

              if (type == 'video') {
                final videoUrl = data['link'];
                final videoId = YoutubePlayer.convertUrlToId(videoUrl);
                final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/'
                    'hqdefault.jpg';

                return Card(
                  color: color,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric
                    (vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(
                      thumbnailUrl,
                      width: 70,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      data['material'],
                      overflow: TextOverflow.ellipsis,
                      style: LightTextTheme.resourceTitle,
                    ),
                    subtitle: Text(
                      data['creator'],
                      overflow: TextOverflow.ellipsis,
                      style: LightTextTheme.resourceCreator,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.redAccent),
                      onPressed: () => _confirmDelete(context, user.uid,
                          favorite.id),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen
                            (videoUrl: videoUrl),
                        ),
                      );
                    },
                  ),
                );
              } else if (type == 'community') {
                final communityName = data['name'];
                final communityDescription = data['description'];

                return Card(
                  color: color,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric
                    (vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      communityName,
                      overflow: TextOverflow.ellipsis,
                      style: LightTextTheme.resourceTitle,
                    ),
                    subtitle: Text(
                      communityDescription,
                      overflow: TextOverflow.ellipsis,
                      style: LightTextTheme.resourceCreator,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors
                          .redAccent),
                      onPressed: () => _confirmDelete
                        (context, user.uid, favorite.id),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CommunityScreen()
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
