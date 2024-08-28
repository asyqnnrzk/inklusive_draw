import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminReviewPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Access Requests'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('admin_access_requests')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final requests = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];

              return ListTile(
                title: Text(request['email']),
                subtitle: Text(request['reason']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        _approveRequest(request.id, request['user_id']);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        _denyRequest(request.id);
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

  Future<void> _approveRequest(String requestId, String userId) async {
    // Update request status in Firestore
    await FirebaseFirestore.instance
        .collection('admin_access_requests')
        .doc(requestId)
        .update({'status': 'approved'});

    // Assign admin role (via Firebase Admin SDK or other methods)
    // For example, you could set a custom claim for the user here.

    // Show a confirmation message
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request approved')));
  }

  Future<void> _denyRequest(String requestId) async {
    // Update request status in Firestore
    await FirebaseFirestore.instance
        .collection('admin_access_requests')
        .doc(requestId)
        .update({'status': 'denied'});

    // Show a confirmation message
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request denied')));
  }
}
