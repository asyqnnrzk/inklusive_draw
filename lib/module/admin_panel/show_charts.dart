import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../source/colors.dart';
import '../../source/progress_indicator_theme.dart';
import '../../source/text_theme.dart';
import 'charts.dart';

class ShowCharts extends StatelessWidget {
  const ShowCharts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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

              return Column(
                children: [
                  SizedBox(
                    height: 500,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        minY: 0,
                        maxY: (resourcesCount > communitiesCount ?
                        resourcesCount
                            : communitiesCount) + 1,
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: resourcesCount,
                                color: primaryColor,
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
                                color: tertiaryColor,
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
                            axisNameWidget: Text(
                              'Number of',
                              style: LightTextTheme.dashboardTxt,
                            ),
                            axisNameSize: 30,
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: SizedBox(
                                    width: 30,
                                    child: Center(
                                      child: Text(
                                        value.toInt().toString(),
                                        style: LightTextTheme.dashboardTxt,
                                        maxLines: 1,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              reservedSize: 40,
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
                  ),
                  const SizedBox(height: 32.0),
                ],
              );
            }
          },
        ),
      const Divider(),
      const SizedBox(height: 6),
      FutureBuilder<Map<DateTime, int>>(
        future: fetchUserGrowthData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
              'Error fetching data',
              style: LightTextTheme.dashboardTxtBold,
            );
          } else {
            final data = snapshot.data!;

            DateTime startDate = DateTime(DateTime.now().year, 1, 1);
            DateTime endDate = data.isNotEmpty ? data.keys.last : DateTime
                .now();
            final months = <DateTime, int>{};

            // Populate the months with zero initial values
            DateTime current = startDate;
            while (current.isBefore(endDate) || (current.year == endDate.year
                && current.month == endDate.month)) {
              months[DateTime(current.year, current.month, 1)] = 0;
              current = DateTime(current.year, current.month + 1, 1);
            }

            // Update the months map with actual data
            for (var entry in data.entries) {
              DateTime dateKey = DateTime(entry.key.year, entry.key.month, 1);
              if (months.containsKey(dateKey)) {
                months[dateKey] = entry.value;
              }
            }

            // Convert Map<DateTime, int> to List<FlSpot>
            List<FlSpot> spots = [];
            final sortedEntries = months.entries.toList()
              ..sort((a, b) => a.key.compareTo(b.key));

            int index = 0;
            for (var entry in sortedEntries) {
              spots.add(FlSpot(index.toDouble(), entry.value.toDouble()));
              index++;
            }

            return Column(
              children: [
                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: false,
                          color: primaryColor,
                          barWidth: 4,
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          axisNameWidget: Text(
                            'Months (${DateTime.now().year})',
                            style: LightTextTheme.dashboardTxt,
                          ),
                          axisNameSize: 30,
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              int monthIndex = value.toInt();
                              if (monthIndex >= 0 && monthIndex < 12) {
                                return Text(
                                  '${monthIndex + 1}',
                                  style: LightTextTheme.dashboardTxt,
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameWidget: Text(
                            'Users Cumulative Growth',
                            style: LightTextTheme.dashboardTxt,
                          ),
                          axisNameSize: 30,
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: LightTextTheme.dashboardTxt,
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
                      minY: 0,
                      minX: 0,
                      maxX: (sortedEntries.length - 1).toDouble(),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            );
          }
        },
      ),
      const Divider(),
      const SizedBox(height: 6),
      FutureBuilder<Map<String, dynamic>>(
        future: fetchActiveInactiveUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
              'Error fetching user data',
              style: LightTextTheme.dashboardTxtBold,
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text(
              'No data available',
              style: LightTextTheme.dashboardTxtBold,
            );
          } else {
            final data = snapshot.data!;
            final int activeUsersCount = data['activeUsersCount'] ?? 0;
            final int inactiveUsersCount = data['inactiveUsersCount'] ?? 0;

            return Column(
              children: [
                SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: activeUsersCount.toDouble(),
                          color: primaryColor.withOpacity(0.5),
                          title: 'Active Users\n$activeUsersCount',
                          radius: 100,
                          titleStyle: LightTextTheme.dashboardTxt
                              .copyWith(fontSize: 14),
                        ),
                        PieChartSectionData(
                          value: inactiveUsersCount.toDouble(),
                          color: tertiaryColor.withOpacity(0.5),
                          title: 'Inactive Users\n$inactiveUsersCount',
                          radius: 100,
                          titleStyle: LightTextTheme.dashboardTxt
                              .copyWith(fontSize: 14),
                        ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  color: tertiaryColor.withOpacity(0.5),
                  child: Text(
                    'Note: Inactive users are those who not logged in for more '
                        'than 30 days',
                    softWrap: true,
                    style: LightTextTheme.dashboardTxt.copyWith(fontSize: 14),
                  ),
                ),
              ],
            );
          }
        },
      ),
      // FutureBuilder<Map<String, dynamic>>(
      //   future: fetchTotalUsers(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const CircularProgressIndicator();
      //     } else if (snapshot.hasError) {
      //       return Text(
      //         'Error fetching user data',
      //         style: LightTextTheme.dashboardTxtBold,
      //       );
      //     } else {
      //       final data = snapshot.data!;
      //       final oldestUsersCount = data['oldestUsersCount'];
      //       final latestUsersCount = data['latestUsersCount'];
      //       final oldestSignUpDate = data['oldestSignUpDate'];
      //       final latestSignUpDate = data['latestSignUpDate'];
      //
      //       return Column(
      //         children: [
      //           SizedBox(
      //             height: 300,
      //             child: PieChart(
      //               PieChartData(
      //                 sections: [
      //                   PieChartSectionData(
      //                     value: oldestUsersCount.toDouble(),
      //                     color: primaryColor.withOpacity(0.5),
      //                     title: 'Oldest Users\n$oldestUsersCount',
      //                     radius: 100,
      //                     titleStyle: LightTextTheme.dashboardTxt
      //                         .copyWith(fontSize: 14),
      //                   ),
      //                   PieChartSectionData(
      //                     value: latestUsersCount.toDouble(),
      //                     color: tertiaryColor.withOpacity(0.5),
      //                     title: 'Latest Users\n$latestUsersCount',
      //                     radius: 100,
      //                     titleStyle: LightTextTheme.dashboardTxt
      //                         .copyWith(fontSize: 14),
      //                   ),
      //                 ],
      //                 sectionsSpace: 2,
      //                 centerSpaceRadius: 50,
      //                 borderData: FlBorderData(show: false),
      //               ),
      //             ),
      //           ),
      //           const SizedBox(height: 16.0),
      //           Text(
      //             'Oldest Sign-Up: ${oldestSignUpDate != null ?
      //             oldestSignUpDate.toString().split(' ')[0] : 'N/A'}',
      //             style: LightTextTheme.dashboardTxt,
      //           ),
      //           Text(
      //             'Latest Sign-Up: ${latestSignUpDate != null ?
      //             latestSignUpDate.toString().split(' ')[0] : 'N/A'}',
      //             style: LightTextTheme.dashboardTxt,
      //           ),
      //         ],
      //       );
      //     }
      //   },
      // ),
      ],
    );
  }
}
