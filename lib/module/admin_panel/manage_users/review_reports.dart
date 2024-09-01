import 'package:InklusiveDraw/module/admin_panel/manage_users/'
    'reported_post.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../source/colors.dart';

class ReviewReports extends StatefulWidget {
  const ReviewReports({super.key});

  @override
  State<ReviewReports> createState() => _ReviewReportsState();
}

class _ReviewReportsState extends State<ReviewReports> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchReports() async {
    List<Map<String, dynamic>> reports = [];

    QuerySnapshot reportSnapshot = await _firestore
        .collection('reports')
        .where('isDeleted', isNotEqualTo: true)
        .get();

    for (var reportDoc in reportSnapshot.docs) {
      Map<String, dynamic> reportData = reportDoc.data() as Map<String,
          dynamic>;
      reportData['reportId'] = reportDoc.id;
      reports.add(reportData);
    }

    return reports;
  }

  void _navigateToPost(String postId, String userIdReported) {
    Get.to(() => ReportedPost(postId: postId, userId: userIdReported));
  }

  Future<void> _showDeleteConfirmationDialog(String reportId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          titleTextStyle: LightTextTheme.deleteBtn,
          content: const Text('Delete this report?'),
          contentTextStyle: LightTextTheme.reportDetails,
          actions: <Widget>[
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
                _deleteReport(reportId);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteReport(String reportId) async {
    try {
      await _firestore.collection('reports').doc(reportId)
          .update({'isDeleted': true});

      await _firestore.collection('reports').doc(reportId)
          .update({'status': 'reviewed'});

      Get.snackbar(
        '',
        '',
        titleText: Text(
          'Done!',
          style: LightTextTheme.snackbarBold,
        ),
        messageText: Text(
          'Report deleted successfully',
          style: LightTextTheme.snackbarTxt,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: greenButton,
        colorText: blackColor,
      );

      setState(() {});
    } catch (e) {
      print('Error deleting report: $e');
      Get.snackbar(
        '',
        '',
        titleText: Text(
          'Uh oh!',
          style: LightTextTheme.snackbarBold,
        ),
        messageText: Text(
          'Failed to delete this report, try again later',
          style: LightTextTheme.snackbarTxt,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redButton,
        colorText: blackColor,
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          'Reports',
          style: LightTextTheme.pageHeadline,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicatorTheme());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No reports available',
                style: LightTextTheme.dashboardTxt,
              ),
            );
          }

          List<Map<String, dynamic>> reports = snapshot.data!;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> report = reports[index];

              return ListTile(
                title: Text('Report ID: \n${report['reportId']}'),
                titleTextStyle: LightTextTheme.dashboardTxt,
                subtitle: Text('Reason: \n${report['reason']}'),
                subtitleTextStyle: LightTextTheme.dashboardTxt,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        _navigateToPost(report['postId'],
                            report['userIdReported']);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmationDialog(report['reportId']);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
