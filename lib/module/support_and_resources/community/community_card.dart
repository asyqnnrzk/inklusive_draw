import 'package:InklusiveDraw/source/colors.dart';
import 'package:flutter/material.dart';
import '../../../model/community_model.dart';
import 'package:InklusiveDraw/source/text_theme.dart';

class CommunityCard extends StatelessWidget {
  final CommunityModel community;
  final bool isFavorited;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const CommunityCard({
    Key? key,
    required this.community,
    required this.isFavorited,
    required this.onFavoriteToggle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: greenButton,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text(
            community.name,
            style: LightTextTheme.resourceTitle,
          ),
          subtitle: Text(
            community.description,
            style: LightTextTheme.resourceCreator,
          ),
          trailing: IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.redAccent : null,
            ),
            onPressed: onFavoriteToggle,
          ),
        ),
      ),
    );
  }
}
