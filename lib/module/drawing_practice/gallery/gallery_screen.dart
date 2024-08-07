import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gallery')),
      body: FutureBuilder<List<File>>(
        future: savedDrawings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No saved drawings found'));
          } else {
            final files = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: files.length,
              itemBuilder: (context, index) {
                final jsonFile = files[index];
                final imageFile = File(jsonFile.path.replaceAll('.json', '.png'));

                return GestureDetector(
                  onTap: () => loadAndEditDrawing(jsonFile),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }
        },
      ),
    );
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
}
