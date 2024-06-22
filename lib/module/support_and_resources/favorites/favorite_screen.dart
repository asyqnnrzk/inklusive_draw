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
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No favorites available'));
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

              if (type == 'video') {
                final videoUrl = data['link'];
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
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('favorites')
                              .doc(favorite.id)
                              .delete();
                        },
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
              } else if (type == 'community') {
                final communityName = data['name'];
                final communityDescription = data['description'];

                return Column(
                  children: [
                    ListTile(
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
                        icon: const Icon(Icons.favorite, color: Colors.redAccent),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('favorites')
                              .doc(favorite.id)
                              .delete();
                        },
                      ),
                    ),
                    const Divider(),
                  ],
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
