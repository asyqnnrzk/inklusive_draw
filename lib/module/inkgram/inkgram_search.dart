import 'package:InklusiveDraw/module/inkgram/inkgram_homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../service/inkgram_service.dart';
import '../../source/colors.dart';
import '../../source/text_theme.dart';
import 'inkgram_profile.dart';

class InkgramSearch extends StatefulWidget {
  const InkgramSearch({super.key});

  @override
  State<InkgramSearch> createState() => _InkgramSearchState();
}

class _InkgramSearchState extends State<InkgramSearch> {
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];
  int _selectedIndex = 1;

  void search(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    try {
      // Perform a broad query to fetch all documents
      QuerySnapshot userResult = await FirebaseFirestore.instance
          .collection('users')
          .get();

      // Filter results client-side
      List<DocumentSnapshot> filteredResults = userResult.docs.where((doc) {
        String username = doc.get('username') ?? '';
        String name = doc.get('name') ?? '';
        return username.toLowerCase().contains(query.toLowerCase()) ||
            name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        searchResults = filteredResults;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Get.to(() => const InkgramHomepage());
    } else if (index == 2) {
      showCreatePostDialog(context);
    } else if (index == 3) {
      Get.to(() => InkgramProfile(userId: FirebaseAuth.instance.currentUser!
          .uid));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _navigateToProfile(String userId) {
    Get.to(() => InkgramProfile(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          'Search in InkGram',
          style: LightTextTheme.pageHeadline,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search users by username or name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                search(query);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                var result = searchResults[index];
                return ListTile(
                  title: Text(result['username'] ?? 'No username'),
                  subtitle: Text(result['name'] ?? 'No name'),
                  onTap: () {
                    _navigateToProfile(result.id);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: secondaryColor,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
