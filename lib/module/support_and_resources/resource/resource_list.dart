import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../source/text_theme.dart';
import '../../app_dashboard/user/user_search.dart';
import 'video_player_screen.dart';

class ResourceList extends StatefulWidget {
  const ResourceList({Key? key}) : super(key: key);

  @override
  State<ResourceList> createState() => _ResourceListState();
}

class _ResourceListState extends State<ResourceList> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _allResources = [];
  List<DocumentSnapshot> _filteredResources = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterResources();
    });
  }

  void _filterResources() {
    setState(() {
      _filteredResources = _allResources.where((resource) {
        return resource['material']
            .toString()
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('resources').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No resources available'));
        }

        _allResources = snapshot.data!.docs;
        if (_searchController.text.isEmpty) {
          _filteredResources = _allResources;
        } else {
          _filteredResources = _allResources.where((resource) {
            return resource['material']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
          }).toList();
        }

        return Column(
          children: [
            UserSearch(controller: _searchController),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredResources.length,
                itemBuilder: (context, index) {
                  final resource = _filteredResources[index];
                  final videoUrl = resource['link'];
                  final videoId = YoutubePlayer.convertUrlToId(videoUrl);
                  final thumbnailUrl =
                      'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

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
                              builder: (context) => VideoPlayerScreen(
                                  videoUrl: videoUrl),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
