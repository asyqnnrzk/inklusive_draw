import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../source/text_theme.dart';
import 'video_player_screen.dart';

class ResourceList extends StatefulWidget {
  final TextEditingController controller;

  const ResourceList({Key? key, required this.controller}) : super(key: key);

  @override
  ResourceListState createState() => ResourceListState();
}

class ResourceListState extends State<ResourceList> {
  final user = FirebaseAuth.instance.currentUser!;
  List<DocumentSnapshot> _allResources = [];
  List<DocumentSnapshot> _filteredResources = [];
  List<DocumentSnapshot> _favoritedItems = [];

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

  Future<void> _toggleFavorite(DocumentSnapshot resource) async {
    final favoritesCollection = FirebaseFirestore.instance.collection('favorites');
    final favoriteDoc = await favoritesCollection
        .where('userId', isEqualTo: user.uid)
        .where('videoId', isEqualTo: resource.id)
        .get();

    if (favoriteDoc.docs.isEmpty) {
      await favoritesCollection.add({
        'userId': user.uid,
        'videoId': resource.id,
        'material': resource['material'],
        'link': resource['link'],
        'creator': resource['creator'],
      });
      setState(() {
        if (favoriteDoc.docs.isEmpty) {
          _favoritedItems.add(resource); // Add the entire resource object
        } else {
          _favoritedItems.remove(resource); // Remove the entire resource object
        }
      });
    } else {
      await favoritesCollection.doc(favoriteDoc.docs.first.id).delete();
      setState(() {
        _favoritedItems.remove(resource); // Remove the favorited item from the list
      });
    }
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
        final isFavorited = _favoritedItems.contains(resource);

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
              trailing: IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : null,
                ),
                onPressed: () {
                  _toggleFavorite(resource);
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
      },
    );
  }
}
