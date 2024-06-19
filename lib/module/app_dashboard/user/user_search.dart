import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UserSearch extends StatelessWidget {
  final TextEditingController controller;

  const UserSearch({Key? key, required this.controller}) : super(key: key);

  void _startVoiceSearch() {
    print('Voice search started');
    // Implement speech-to-text searching
  }

  void _clearSearch() {
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(LineAwesomeIcons.search_solid),
        suffixIcon: SizedBox(
          width: 96,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: const Icon(LineAwesomeIcons.microphone_solid),
                onPressed: _startVoiceSearch,
              ),
              IconButton(
                icon: const Icon(LineAwesomeIcons.times_solid),
                onPressed: _clearSearch,
              ),
            ],
          ),
        ),
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
