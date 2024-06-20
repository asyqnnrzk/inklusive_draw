import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../source/text_theme.dart';
import '../../app_dashboard/user/user_search.dart';
import 'video_player_screen.dart';

class ResourceList extends StatefulWidget {
  final TextEditingController controller;

  const ResourceList({Key? key, required this.controller}) : super(key: key);

  @override
  State<ResourceList> createState() => ResourceListState();

  void filterResources() {
    // This is a placeholder, the actual logic will be in the State class.
  }
}

class ResourceListState extends State<ResourceList> {
  final user = FirebaseAuth.instance.currentUser!;
  List<DocumentSnapshot> _allResources = [];
  List<DocumentSnapshot> _filteredResources = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSearchChanged);
    _fetchResources();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    if (widget.controller.text.isEmpty) {
      setState(() {
        _filteredResources = _allResources;
      });
    }
  }

  void _fetchResources() {
    FirebaseFirestore.instance.collection('resources').snapshots().listen((snapshot) {
      setState(() {
        _allResources = snapshot.docs;
        _filteredResources = _allResources;
      });
    });
  }

  void filterResources() {
    setState(() {
      _filteredResources = _allResources.where((resource) {
        return resource['material']
            .toString()
            .toLowerCase()
            .contains(widget.controller.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredResources.length,
      itemBuilder: (context, index) {
        final resource = _filteredResources[index];
        final videoUrl = resource['link'];
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
                resource['material'],
                overflow: TextOverflow.ellipsis,
                style: LightTextTheme.resourceTitle,
              ),
              subtitle: Text(
                resource['creator'],
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
  }
}
