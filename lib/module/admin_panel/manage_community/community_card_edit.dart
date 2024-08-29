import 'package:InklusiveDraw/source/colors.dart';
import 'package:flutter/material.dart';
import '../../../model/community_model.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import '../manage_resource_community.dart';

class CommunityCardEdit extends StatefulWidget {
  final CommunityModel community;
  final VoidCallback onTap;

  const CommunityCardEdit({
    Key? key,
    required this.community,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CommunityCardEdit> createState() => _CommunityCardEditState();
}

class _CommunityCardEditState extends State<CommunityCardEdit> {
  void _editCommunity(String communityId) async {
    editCommunity(context, communityId);
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
            icon: const Icon(Icons.edit),
            color: primaryColor,
            onPressed: () {
              _editCommunity(widget.community.id);
            },
          ),
        ),
      ),
    );
  }
}
