import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../source/text_theme.dart';
import '../resource/video_player_screen.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: LightTextTheme.profileHeadline,
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
            .collection('favorites')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No favorite videos available'));
          }

          final favorites = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              final videoUrl = favorite['link'];
              final videoId = YoutubePlayer.convertUrlToId(videoUrl);
              final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

              return Column(
                children: [
                  ListTile(
                    leading: Image.network(
                      thumbnailUrl,
                      width: 70,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      favorite['material'],
                      overflow: TextOverflow.ellipsis,
                      style: LightTextTheme.resourceTitle,
                    ),
                    subtitle: Text(
                      favorite['creator'],
                      overflow: TextOverflow.ellipsis,
                      style: LightTextTheme.resourceCreator,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
