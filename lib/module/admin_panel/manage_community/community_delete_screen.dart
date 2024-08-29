import 'package:InklusiveDraw/module/admin_panel/manage_community/'
    'community_card_delete.dart';
import 'package:InklusiveDraw/module/support_and_resources/community/'
    'community_search.dart';
import 'package:InklusiveDraw/module/support_and_resources/community/'
    'forum/forum_homepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../model/community_model.dart';
import 'package:InklusiveDraw/source/text_theme.dart';

class CommunityDelete extends StatefulWidget {
  const CommunityDelete({super.key});

  @override
  _CommunityDeleteState createState() => _CommunityDeleteState();
}

class _CommunityDeleteState extends State<CommunityDelete> {
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
    search(searchController.text);
  }

  void search(String query) async {
    if (query.isEmpty) {
      setState(() {
        displayedCommunities = allCommunities;
      });
      return;
    }

    try {
      QuerySnapshot userResult = await FirebaseFirestore.instance
          .collection('communities')
          .get();

      List<CommunityModel> filteredResults = userResult.docs.map((doc) {
        return CommunityModel.fromFirestore(doc);
      }).where((community) {
        return community.name.toLowerCase().contains(query.toLowerCase()) ||
            community.description.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        displayedCommunities = filteredResults;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchCommunities() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection
        ('communities').get();
      setState(() {
        allCommunities = snapshot.docs.map((doc) => CommunityModel
            .fromFirestore(doc)).toList();
        displayedCommunities = allCommunities;
      });
    } catch (e) {
      print('Error fetching communities: $e');
    }
  }

  Future<void> _loadFavorites() async {
    try {
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
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community',
          style: LightTextTheme.pageHeadline,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 24.0),
                CommunitySearch(onSearch: search),
                const SizedBox(height: 16.0),
                displayedCommunities.isEmpty
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
                        'No communities found',
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
                  itemCount: displayedCommunities.length,
                  itemBuilder: (context, index) {
                    final community = displayedCommunities[index];
                      (community.id);
                    return CommunityCardDelete(
                      community: community,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ForumHomepage(communityId:
                            community.id),
                          ),
                        );
                      },
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
