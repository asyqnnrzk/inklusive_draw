import 'package:InklusiveDraw/source/colors.dart';
import 'package:InklusiveDraw/source/progress_indicator_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../source/text_theme.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({Key? key}) : super(key: key);

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    if (user != null) {
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user!.uid)
          .get();

      if (adminDoc.exists) {
        setState(() {
          isAdmin = true;
        });
      } else {
        setState(() {
          isAdmin = false;
        });
      }
    }
  }

  Future<void> _updateRequestStatus(String requestId, String status) async {
    await FirebaseFirestore.instance
        .collection('admin_access_requests')
        .doc(requestId)
        .update({'status': status});
  }

  void _confirmDeleteRequest(String requestId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Request',
            style: LightTextTheme.deleteBtn,
          ),
          content: Text(
            'Delete this request?',
            style: LightTextTheme.reportDetails,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'Cancel',
                style: LightTextTheme.cancelBtn,
              ),
            ),
            TextButton(
              onPressed: () {
                // If the user confirms, delete the request
                Navigator.pop(context, true);
                _deleteRequest(requestId);
              },
              child: Text(
                'Yes',
                style: LightTextTheme.yesBtn,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('admin_access_requests')
          .doc(requestId)
          .delete();

      Get.snackbar(
        '',
        '',
        titleText: Text(
          'Request Deleted',
          style: LightTextTheme.cancelBtn,
        ),
        messageText: Text(
          'The admin access request has been successfully deleted.',
          style: LightTextTheme.reportDetails,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: secondaryColor,
        colorText: blackColor
      );
    } catch (e) {
      // Handle any errors
      Get.snackbar(
        '',
        '',
        titleText: Text(
          'Uh oh!',
          style: LightTextTheme.reportBtn,
        ),
        messageText: Text(
          'Failed to delete the request. Please try again.',
          style: LightTextTheme.reportDetails,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: secondaryColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Admin Requests',
          style: LightTextTheme.pageHeadline,
        ),
      ),
      body: isAdmin
          ? StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admin_access_requests')
            .orderBy('requested_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicatorTheme());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching requests.',
                style: LightTextTheme.reportDetails,
              ));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No requests found.',
                style: LightTextTheme.reportDetails,
              ));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final requestId = request.id;
              final username = request['username'] ?? 'No Username';
              final email = request['email'] ?? 'No Email';
              final reason = request['reason'] ?? 'No Reason';
              final status = request['status'] ?? 'pending';

              return Column(
                children: [
                  ListTile(
                    title: Text('Username: $username'),
                    titleTextStyle: LightTextTheme.dashboardTxt,
                    subtitle: Text('Reason: $reason\n$email'),
                    subtitleTextStyle: LightTextTheme.dashboardTxtBold,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check,
                              color: status == 'approved' ? Colors.green : null
                          ),
                          onPressed: () => _updateRequestStatus
                            (requestId, 'approved'),
                        ),
                        IconButton(
                          icon: Icon(Icons.clear,
                              color: status == 'denied' ? Colors.red : null
                          ),
                          onPressed: () => _updateRequestStatus
                            (requestId, 'denied'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red
                          ),
                          onPressed: () => _confirmDeleteRequest(requestId),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              );
            },
          );
        },
      )
          : Center(
        child: Text(
          'You do not have permission to view this content.',
          style: LightTextTheme.reportDetails,
        ),
      ),
    );
  }
}
