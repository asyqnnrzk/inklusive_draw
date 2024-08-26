import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../source/text_theme.dart';

class ResourceSearch extends StatefulWidget {
  final void Function(String) onSearch;

  const ResourceSearch({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<ResourceSearch> createState() => _ResourceSearchState();
}

class _ResourceSearchState extends State<ResourceSearch> {
  final TextEditingController _searchController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

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
            _searchController.text = val.recognizedWords;
            widget.onSearch(val.recognizedWords);
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search for resource...',
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

