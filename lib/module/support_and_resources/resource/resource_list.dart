import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
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
  List<String> _favoritedItemIds = []; // Store favorited item IDs instead of documents

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSearchChanged);
    _fetchResources();
    _loadFavorites(); // Load favorites when initializing the widget
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
        _favoritedItemIds.add(resource.id); // Add the favorited item ID
      });
    } else {
      await favoritesCollection.doc(favoriteDoc.docs.first.id).delete();
      setState(() {
        _favoritedItemIds.remove(resource.id); // Remove the favorited item ID
      });
    }
    _saveFavorites(); // Save the favorited item IDs after toggling favorites
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoritedItemIds = prefs.getStringList('favoritedItemIds');
    if (favoritedItemIds != null) {
      setState(() {
        _favoritedItemIds = favoritedItemIds;
      });
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoritedItemIds', _favoritedItemIds);
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
        final isFavorited = _favoritedItemIds.contains(resource.id); // Check if the favorited item IDs list contains the current resource ID

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
