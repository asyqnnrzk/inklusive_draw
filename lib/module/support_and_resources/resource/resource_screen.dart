import 'package:InklusiveDraw/module/app_dashboard/user/user_search.dart';
import 'package:InklusiveDraw/module/support_and_resources/resource/resource_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../source/text_theme.dart';
import '../favorites/favorite_screen.dart';

class ResourceScreen extends StatefulWidget {
  const ResourceScreen({super.key});

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ResourceListState> _resourceListKey = GlobalKey<ResourceListState>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    _resourceListKey.currentState?.filterResources();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resources',
          style: LightTextTheme.profileHeadline,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FavoriteScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              UserSearch(controller: _searchController, onSearch: _onSearch),
              const SizedBox(height: 16.0),
              ResourceList(key: _resourceListKey, controller: _searchController),
            ],
          ),
        ),
      ),
    );
  }
}
