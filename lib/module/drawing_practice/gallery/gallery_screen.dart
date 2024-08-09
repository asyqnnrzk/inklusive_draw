import 'dart:convert';
import 'dart:io';
import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../../source/text_theme.dart';
import '../drawing/drawing_page.dart';
import '../drawing/widgets/drawing_canvas.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late Future<List<File>> savedDrawings;

  @override
  void initState() {
    super.initState();
    savedDrawings = listSavedDrawings();
  }

  Future<List<File>> listSavedDrawings() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().whereType<File>().toList();
    return files.where((file) => file.path.endsWith('.json')).toList();
  }

  void loadAndEditDrawing(File file) async {
    final drawingData = jsonDecode(await file.readAsString());
    final List<CanvasDrawnLine> loadedLines = (drawingData['lines'] as List)
        .map((lineJson) => CanvasDrawnLine.fromJson(lineJson))
        .toList();
    final loadedBackgroundColor = Color(drawingData['backgroundColor']);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DrawingPage(
          initialLines: loadedLines,
          initialBackgroundColor: loadedBackgroundColor,
        ),
      ),
    );
  }

  void editDrawing(File file) async {
    final drawingData = jsonDecode(await file.readAsString());
    final List<CanvasDrawnLine> loadedLines = (drawingData['lines'] as List)
        .map((lineJson) => CanvasDrawnLine.fromJson(lineJson))
        .toList();
    final loadedBackgroundColor = Color(drawingData['backgroundColor']);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DrawingPage(
          initialLines: loadedLines,
          initialBackgroundColor: loadedBackgroundColor,
        ),
      ),
    );
  }

  void deleteDrawing(File jsonFile, File imageFile) async {
    try {
      if (await jsonFile.exists()) {
        await jsonFile.delete();
      }
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
      setState(() {
        savedDrawings = listSavedDrawings(); // Refresh the gallery
      });
    } catch (e) {
      // Handle error if necessary
      print('Error deleting drawing: $e');
    }
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
      body: FutureBuilder<List<File>>(
        future: savedDrawings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicatorTheme());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No saved drawings found'));
          } else {
            final files = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: files.length,
              itemBuilder: (context, index) {
                final jsonFile = files[index];
                final imageFile = File(jsonFile.path.replaceAll('.json', '.png'
                ));

                try {
                  final drawingData = jsonDecode(jsonFile.readAsStringSync());
                  final name = drawingData['name'] ?? 'Untitled';
                  final dateCreated = drawingData.containsKey('dateCreated')
                      ? DateTime.parse(drawingData['dateCreated'])
                      : DateTime.now();

                  return GestureDetector(
                    onTap: () => loadAndEditDrawing(jsonFile),
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
                                  'Created on: ${dateCreated.toLocal().toString
                                    ().split(' ')[0]}',
                                  style: LightTextTheme.drawingLabel,
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style:ElevatedButton.styleFrom(
                                        elevation: 0.0
                                      ),
                                      onPressed: () => editDrawing(jsonFile),
                                      child: Text(
                                        'Edit',
                                        style: LightTextTheme.editBtn,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: redButton
                                      ),
                                      onPressed: () => deleteDrawing(jsonFile,
                                          imageFile),
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
    );
  }
}
