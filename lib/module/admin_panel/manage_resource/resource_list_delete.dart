import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../source/text_theme.dart';
import '../../support_and_resources/resource/video_player_screen.dart';
import '../manage_resource_community.dart';

class ResourceListDelete extends StatefulWidget {
  final TextEditingController controller;

  const ResourceListDelete({Key? key, required this.controller}) :
        super(key: key);

  @override
  ResourceListDeleteState createState() => ResourceListDeleteState();
}

class ResourceListDeleteState extends State<ResourceListDelete> {
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
    filterResources(widget.controller.text);
  }

  void _fetchResources() {
    FirebaseFirestore.instance.collection('resources').snapshots().listen(
          (snapshot) {
        setState(() {
          _allResources = snapshot.docs;
          _filteredResources = _allResources;
        });
      },
    );
  }

  void filterResources(String query) {
    setState(() {
      final lowerCaseQuery = query.toLowerCase();
      _filteredResources = _allResources.where((resource) {
        return resource['material']
            .toString()
            .toLowerCase()
            .contains(lowerCaseQuery);
      }).toList();
    });
  }

  void _deleteResource(String resourceId) async {
    deleteResource(context, resourceId);
  }

  Widget buildResourceTile(DocumentSnapshot resource, String thumbnailUrl) {
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
            maxLines: null,
            softWrap: true,
            style: LightTextTheme.resourceTitle,
          ),
          subtitle: Text(
            resource['creator'],
            overflow: TextOverflow.ellipsis,
            style: LightTextTheme.resourceCreator,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              _deleteResource(resource.id);
            },
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(videoUrl:
                resource['link']),
              ),
            );
          },
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _filteredResources.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16.0),
          Text(
            'No resources found',
            style: LightTextTheme.hintTxt,
          ),
          Text(
            'Please try another keyword',
            style: LightTextTheme.hintTxt,
          ),
        ],
      ),
    )
        : ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredResources.length,
      itemBuilder: (context, index) {
        final resource = _filteredResources[index];
        final videoUrl = resource['link'];
        final videoId = YoutubePlayer.convertUrlToId(videoUrl);
        final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/'
            'hqdefault.jpg';

        return buildResourceTile(resource, thumbnailUrl);
      },
    );
  }
}
