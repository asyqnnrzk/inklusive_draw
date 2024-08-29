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

  Future<void> _updateRequestStatus(String requestId, String status) async {
    await FirebaseFirestore.instance
        .collection('admin_access_requests')
        .doc(requestId)
        .update({'status': status});
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admin_access_requests')
            .orderBy('requested_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicatorTheme());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching requests.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No requests found.'));
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

              return ListTile(
                title: Text(username),
                subtitle: Text('Reason: $reason\nEmail: $email'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: status == 'approved' ? Colors.green : null),
                      onPressed: () => _updateRequestStatus(requestId, 'approved'),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear, color: status == 'denied' ? Colors.red : null),
                      onPressed: () => _updateRequestStatus(requestId, 'denied'),
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
