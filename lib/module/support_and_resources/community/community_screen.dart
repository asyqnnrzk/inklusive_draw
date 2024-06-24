import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../model/community_model.dart';
import '../favorites/favorite_screen.dart';
import 'community_card.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import '../../app_dashboard/user/user_search.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController searchController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  List<CommunityModel> allCommunities = [];
  List<CommunityModel> displayedCommunities = [];
  List<String> favoritedCommunityIds = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _fetchCommunities();
    _loadFavorites();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      displayedCommunities = allCommunities.where((community) {
        return community.name.toLowerCase().contains(searchController
            .text.toLowerCase());
      }).toList();
    });
  }

  Future<void> _fetchCommunities() async {
    final snapshot = await FirebaseFirestore.instance.collection('communities')
        .get();
    setState(() {
      allCommunities = snapshot.docs.map((doc) => CommunityModel
          .fromFirestore(doc)).toList();
      displayedCommunities = allCommunities;
    });
  }

  Future<void> _loadFavorites() async {
    final favoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites');
    final favoritesSnapshot = await favoritesCollection.get();

    setState(() {
      favoritedCommunityIds = favoritesSnapshot.docs
          .where((doc) => doc['type'] == 'community')
          .map((doc) => doc['community_id'] as String)
          .toList();
    });
  }

  Future<void> _toggleFavorite(CommunityModel community) async {
    final favoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites');
    final favoriteDoc = await favoritesCollection
        .where('community_id', isEqualTo: community.id)
        .get();

    if (favoriteDoc.docs.isEmpty) {
      // Add to favorites
      await favoritesCollection.add({
        'type': 'community',
        'community_id': community.id,
        'name': community.name,
        'description': community.description,
      });
      setState(() {
        favoritedCommunityIds.add(community.id);
      });
    } else {
      // Remove from favorites
      await favoritesCollection.doc(favoriteDoc.docs.first.id).delete();
      setState(() {
        favoritedCommunityIds.remove(community.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community',
          style: LightTextTheme.profileHeadline,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FavoriteScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 24.0),
                UserSearch(controller: searchController, onSearch:
                _onSearchChanged),
                const SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedCommunities.length,
                  itemBuilder: (context, index) {
                    final community = displayedCommunities[index];
                    final isFavorited = favoritedCommunityIds.contains(
                        community.id);
                    return CommunityCard(
                      community: community,
                      isFavorited: isFavorited,
                      onFavoriteToggle: () => _toggleFavorite(community),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
