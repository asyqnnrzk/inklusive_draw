import 'dart:convert';
import 'dart:io';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../../service/drawing_service.dart';
import '../../../source/text_theme.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class GalleryScreen extends StatefulWidget {
  final String? initialFilePath;

  const GalleryScreen({super.key, this.initialFilePath});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late Future<List<File>> savedDrawings;
  TextEditingController searchController = TextEditingController();
  List<File> filteredDrawings = [];
  late stt.SpeechToText _speech;
  bool _isListening = false;
  final DrawingService drawingOps = DrawingService();

  @override
  void initState() {
    super.initState();
    savedDrawings = listSavedDrawings();
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

  Future<List<File>> listSavedDrawings() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().whereType<File>().toList();
    return files.where((file) => file.path.endsWith('.json')).toList();
  }

  void search(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredDrawings.clear();
      });
      return;
    }

    try {
      final allDrawings = await savedDrawings;
      final results = allDrawings.where((file) {
        final drawingData = jsonDecode(file.readAsStringSync());
        final name = drawingData['name'] ?? 'Untitled';
        return name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        filteredDrawings = results;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void refreshGallery() {
    setState(() {
      savedDrawings = listSavedDrawings();
    });
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
          'My Gallery',
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
                hintText: 'Search drawings...',
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
                search(query);
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<File>>(
              future: savedDrawings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicatorTheme());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No saved drawings found',
                      style: LightTextTheme.dashboardTxtBold,
                    )
                  );
                } else {
                  final files = filteredDrawings.isEmpty
                      ? snapshot.data!
                      : filteredDrawings;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final jsonFile = files[index];
                      final imageFile = File(jsonFile.path.replaceAll('.json', '.png'));

                      try {
                        final drawingData = jsonDecode(jsonFile.readAsStringSync());
                        final name = drawingData['name'] ?? 'Untitled';
                        final dateCreated = drawingData.containsKey('dateCreated')
                            ? DateTime.parse(drawingData['dateCreated'])
                            : DateTime.now();

                        return GestureDetector(
                          onTap: () {
                            // Navigate to gallery screen with exact drawing
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GalleryScreen(
                                  initialFilePath: jsonFile.path,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: primaryColor,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.file(
                                    imageFile,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: LightTextTheme.drawingLabel,
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        'Created on: ${dateCreated.toLocal().toString().split(' ')[0]}',
                                        style: LightTextTheme.drawingLabel,
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0.0,
                                            ),
                                            onPressed: () => drawingOps.editDrawing(context, jsonFile),
                                            child: Text(
                                              'Edit',
                                              style: LightTextTheme.editBtn,
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: redButton,
                                            ),
                                            onPressed: () => drawingOps.deleteDrawing(
                                              context,
                                              jsonFile,
                                              imageFile,
                                              refreshGallery,
                                            ),
                                            child: Text(
                                              'Delete',
                                              style: LightTextTheme.deleteBtn,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } catch (e) {
                        return const Center(child: Text('Error loading drawing'));
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
