import 'dart:io';
import 'dart:ui';

class UserDashboardContent {
  final String title;
  final String imagePath;
  final VoidCallback onPress;

  UserDashboardContent({
    required this.title,
    required this.imagePath,
    required this.onPress,
  });

  // Create an instance from drawing data
  factory UserDashboardContent.fromDrawingData(String title, File jsonFile) {
    // Derive the image file path from the JSON file path
    final imageFilePath = jsonFile.path.replaceAll('.json', '.png');

    return UserDashboardContent(
      title: title,
      imagePath: imageFilePath,
      onPress: () {
        // Define what happens when this content is pressed
        print('Tapped on: $title');
      },
    );
  }
}
