import 'package:InklusiveDraw/module/app_dashboard/user/user_search.dart';
import 'package:InklusiveDraw/module/support_and_resources/resource/resource_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ResourceScreen extends StatelessWidget {
  const ResourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              UserSearch(),
              SizedBox(height: 16.0),
              ResourceList()
            ],
          ),
        ),
      ),
    );
  }
}
