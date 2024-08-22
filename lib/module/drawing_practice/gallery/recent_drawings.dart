import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../model/user/user_content_model.dart';

class RecentDrawings {
  final List<UserDashboardContent> recentDrawings;

  RecentDrawings({required this.recentDrawings});

  // Fetch recent drawings from the gallery
  static Future<RecentDrawings> fetchRecentDrawings() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().whereType<File>().toList();
    final jsonFiles = files.where((file) => file.path.endsWith('.json')).toList();

    // Sort files by last modified date in descending order
    jsonFiles.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    // Take the first 3 files (latest ones)
    final recentFiles = jsonFiles.take(3).toList();

    final drawings = recentFiles.map((file) {
      final drawingData = jsonDecode(file.readAsStringSync());
      final title = drawingData['name'] ?? 'Untitled';
      return UserDashboardContent.fromDrawingData(title, file);
    }).toList();

    return RecentDrawings(recentDrawings: drawings);
  }
}
