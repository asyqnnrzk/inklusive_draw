import 'package:flutter/material.dart';
import '../../../source/colors.dart';
import '../../../source/text_theme.dart';
import '../../admin_panel/manage_resource_community.dart';

class AdminContent extends StatelessWidget {

  AdminContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resources and Communities',
          style: LightTextTheme.dashboardHeadline,
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => addResource(context),
                  icon: ClipOval(
                    child: Image.asset(
                      'assets/icons/add_resource.png',
                      width: 60,
                      height: 60,
                      color: primaryColor,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Add New \nResource',
                    style: LightTextTheme.adminAddBtn,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => deleteResource(context),
                  icon: ClipOval(
                    child: Image.asset(
                      'assets/icons/delete_resource.png',
                      width: 60,
                      height: 60,
                      color: primaryColor,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Delete \nResource',
                    style: LightTextTheme.adminAddBtn,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => addCommunity(context),
                  icon: ClipOval(
                    child: Image.asset(
                      'assets/icons/add_community.png',
                      width: 60,
                      height: 60,
                      color: primaryColor,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Add New \nCommunity',
                    style: LightTextTheme.adminAddBtn,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => deleteCommunity(context),
                  icon: ClipOval(
                    child: Image.asset(
                      'assets/icons/delete_community.png',
                      width: 60,
                      height: 60,
                      color: primaryColor,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Delete \nCommunity',
                    style: LightTextTheme.adminAddBtn,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32.0),
        // InkGram section or other content as needed
      ],
    );
  }
}
