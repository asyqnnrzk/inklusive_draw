import 'package:InklusiveDraw/source/colors.dart';
import 'package:flutter/material.dart';
import '../../../model/community_model.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import '../manage_resource_community.dart';

class CommunityCardDelete extends StatefulWidget {
  final CommunityModel community;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CommunityCardDelete({
    Key? key,
    required this.community,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<CommunityCardDelete> createState() => _CommunityCardDeleteState();
}

class _CommunityCardDeleteState extends State<CommunityCardDelete> {
  void _deleteCommunity(String communityId) async {
    deleteCommunity(context, communityId, widget.onDelete);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        color: greenButton,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text(
            widget.community.name,
            style: LightTextTheme.resourceTitle,
          ),
          subtitle: Text(
            widget.community.description,
            style: LightTextTheme.resourceCreator,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              _deleteCommunity(widget.community.id);
            },
          ),
        ),
      ),
    );
  }
}
