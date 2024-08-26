import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../source/text_theme.dart';

class CommunitySearch extends StatefulWidget {
  final void Function(String) onSearch;

  const CommunitySearch({Key? key, required this.onSearch})
      : super(key: key);

  @override
  State<CommunitySearch> createState() => _CommunitySearchState();
}

class _CommunitySearchState extends State<CommunitySearch> {
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];

  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    widget.onSearch(searchController.text);
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
            widget.onSearch(val.recognizedWords);
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
          .collection('communities')
          .get();

      List<DocumentSnapshot> filteredResults = userResult.docs.where((doc) {
        String name = doc.get('name') ?? '';
        String description = doc.get('description') ?? '';
        return name.toLowerCase().contains(query.toLowerCase()) ||
            description.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        searchResults = filteredResults;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search for community...',
          hintStyle: LightTextTheme.hintTxt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
            onPressed: _listen,
          ),
        ),
        onChanged: (query) {
          widget.onSearch(query);
        },
      ),
    );
  }
}
