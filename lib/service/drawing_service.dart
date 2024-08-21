import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../module/drawing_practice/drawing/drawing_page.dart';
import '../module/drawing_practice/drawing/widgets/drawing_canvas.dart';
import '../source/text_theme.dart';

class DrawingService {
  Future<void> loadAndEditDrawing(BuildContext context, File file) async {
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

  Future<void> editDrawing(BuildContext context, File file) async {
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

  Future<void> deleteDrawing(BuildContext context, File jsonFile, File imageFile, Function refreshGallery) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Drawing',
            style: LightTextTheme.deleteBtn,
          ),
          content: Text(
            'Are you sure you want to delete this drawing?',
            style: LightTextTheme.reportDetails,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancel',
                style: LightTextTheme.cancelBtn,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Delete',
                style: LightTextTheme.deleteBtn,
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        if (await jsonFile.exists()) {
          await jsonFile.delete();
        }
        if (await imageFile.exists()) {
          await imageFile.delete();
        }
        refreshGallery(); // Call the method to refresh the gallery
      } catch (e) {
        // Handle error if necessary
        print('Error deleting drawing: $e');
      }
    }
  }
}
