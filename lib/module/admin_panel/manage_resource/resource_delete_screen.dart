import 'package:InklusiveDraw/module/admin_panel/manage_resource/'
    'resource_list_delete.dart';
import 'package:InklusiveDraw/module/support_and_resources/resource/'
    'resource_list.dart';
import 'package:InklusiveDraw/module/support_and_resources/resource/'
    'resource_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../source/text_theme.dart';

class ResourceDelete extends StatefulWidget {
  const ResourceDelete({super.key});

  @override
  State<ResourceDelete> createState() => _ResourceDeleteState();
}

class _ResourceDeleteState extends State<ResourceDelete> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ResourceListState> _resourceListKey =
  GlobalKey<ResourceListState>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    _resourceListKey.currentState?.filterResources(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resources',
          style: LightTextTheme.pageHeadline,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ResourceSearch(onSearch: _onSearch),
              const SizedBox(height: 16.0),
              ResourceListDelete(key: _resourceListKey, controller:
              _searchController),
            ],
          ),
        ),
      ),
    );
  }
}
