import 'package:InklusiveDraw/module/admin_panel/admin_requests_screen.dart';
import 'package:InklusiveDraw/module/admin_panel/manage_community/'
    'community_delete_screen.dart';
import 'package:InklusiveDraw/module/admin_panel/manage_community/'
    'community_edit_screen.dart';
import 'package:InklusiveDraw/module/admin_panel/manage_resource/'
    'resource_delete_screen.dart';
import 'package:InklusiveDraw/module/admin_panel/manage_resource/'
    'resource_edit_screen.dart';
import 'package:InklusiveDraw/module/admin_panel/manage_users/user_list_screen.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../source/colors.dart';
import '../../../source/text_theme.dart';
import '../../admin_panel/charts.dart';
import '../../admin_panel/manage_resource_community.dart';

class AdminContent extends StatelessWidget {

  AdminContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admin Tools',
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
                    onPressed: () => Get.to(() => const ResourceDelete()),
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
                    onPressed: () => Get.to(() => const CommunityDelete()),
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
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => Get.to(() => const ResourceEdit()),
                    icon: ClipOval(
                      child: Image.asset(
                        'assets/icons/edit_resource.png',
                        width: 60,
                        height: 60,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Edit \nResource',
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
                    onPressed: () => Get.to(() => const CommunityEdit()),
                    icon: ClipOval(
                      child: Image.asset(
                        'assets/icons/edit_community.png',
                        width: 60,
                        height: 60,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Edit \nCommunity',
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
                    onPressed: () => Get.to(() => const UserListScreen()),
                    icon: ClipOval(
                      child: Image.asset(
                        'assets/icons/manage_user.png',
                        width: 60,
                        height: 60,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Manage \nUsers',
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
                    onPressed: () => Get.to(() => const AdminRequestsScreen()),
                    icon: ClipOval(
                      child: Image.asset(
                        'assets/icons/admin_requests.png',
                        width: 60,
                        height: 60,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Admin \nRequests',
                      style: LightTextTheme.adminAddBtn,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          Text(
            'Graphs and Charts',
            style: LightTextTheme.dashboardHeadline,
          ),
          const SizedBox(height: 16.0),
          FutureBuilder<Map<String, int>>(
            future: fetchCounts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicatorTheme();
              } else if (snapshot.hasError) {
                return Text(
                  'Error fetching data',
                  style: LightTextTheme.dashboardTxtBold,
                );
              } else {
                final data = snapshot.data!;

                double resourcesCount = data['resources']?.toDouble() ?? 0;
                double communitiesCount = data['communities']?.toDouble() ?? 0;

                return SizedBox(
                  height: 500,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      minY: 0,
                      maxY: (resourcesCount > communitiesCount ? resourcesCount
                          : communitiesCount) + 1,
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: resourcesCount,
                              color: Colors.blue,
                              width: 20,
                            ),
                          ],
                          showingTooltipIndicators: [0],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: communitiesCount,
                              color: Colors.green,
                              width: 20,
                            ),
                          ],
                          showingTooltipIndicators: [0],
                        ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return Text(
                                    'Resources',
                                    style: LightTextTheme.dashboardTxt
                                  );
                                case 1:
                                  return Text(
                                    'Communities',
                                    style: LightTextTheme.dashboardTxt
                                  );
                                default:
                                  return const Text('');
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: LightTextTheme.dashboardTxt
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
