import 'dart:math';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String title;
  final String content;
  final String author;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  PostCard({
    required this.title,
    required this.content,
    required this.author,
    required this.onTap,
    this.onDelete,
  });

  // List of pastel colors
  final List<Color> _pastelColors = [
    const Color(0xFFE5B9E2), // Light pastel purple
    const Color(0xFFB9E5B9), // Light pastel green
    const Color(0xFFFFB9B9), // Light pastel pink
    const Color(0xFFB9E2F5), // Light pastel blue
    const Color(0xFFFFE5B9), // Light pastel beige
    const Color(0xFFFFC9C9), // Light pastel light pink
    const Color(0xFFB9E5E0), // Light pastel mint
  ];

  @override
  Widget build(BuildContext context) {
    // Generate a random index to select a pastel color
    final random = Random();
    final color = _pastelColors[random.nextInt(_pastelColors.length)];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      color: color,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  title,
                  style: LightTextTheme.forumTitle,
                ),
                subtitle: Text(
                  content,
                  style: LightTextTheme.forumLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: onTap,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'by $author',
                  style: LightTextTheme.forumBy,
                ),
              ),
            ],
          ),
          if (onDelete != null)
            Positioned(
              top: 8.0,
              right: 8.0,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                iconSize: 16.0,
                onPressed: () {
                  // Show confirmation dialog before deleting
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Delete Post?',
                          style: LightTextTheme.deleteBtn,
                        ),
                        content: Text(
                          'Are you sure you want to delete this post?',
                          style: LightTextTheme.reportDetails,
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'Cancel',
                              style: LightTextTheme.cancelBtn,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              'Delete',
                              style: LightTextTheme.deleteBtn,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              onDelete!();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
