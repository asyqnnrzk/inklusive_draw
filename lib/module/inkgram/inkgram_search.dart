import 'package:InklusiveDraw/module/inkgram/inkgram_homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../service/inkgram_service.dart';
import '../../source/colors.dart';
import '../../source/text_theme.dart';
import 'inkgram_notifications.dart';
import 'inkgram_profile.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class InkgramSearch extends StatefulWidget {
  const InkgramSearch({super.key});

  @override
  State<InkgramSearch> createState() => _InkgramSearchState();
}

class _InkgramSearchState extends State<InkgramSearch> {
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];
  int _selectedIndex = 1;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _hasInteractedWithSearch = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Error: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            searchController.text = val.recognizedWords;
            search(val.recognizedWords);
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void search(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    try {
      QuerySnapshot userResult = await FirebaseFirestore.instance
          .collection('users')
          .where('isDeleted', isEqualTo: false)
          .get();

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
      Get.to(() => const InkgramNotifications());
    } else if (index == 4) {
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
                hintText: 'Search for InkGram users...',
                hintStyle: LightTextTheme.hintTxt,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _listen,
                ),
              ),
              onTap: () {
                setState(() {
                  _hasInteractedWithSearch = true;
                });
              },
              onChanged: (query) {
                search(query);
              },
            ),
          ),
          Expanded(
            child: _hasInteractedWithSearch
                ? (searchResults.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: blackColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: LightTextTheme.hintTxt,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Don't give up, let's try again!",
                    style: LightTextTheme.hintTxt,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
                : ListView.builder(
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
            ))
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/seek.png',
                    color: blackColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Start searching...',
                    style: LightTextTheme.hintTxt,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter a username or name to search.',
                    style: LightTextTheme.hintTxt,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
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
