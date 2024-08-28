import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestAdminAccessScreen extends StatefulWidget {
  @override
  _RequestAdminAccessScreenState createState() => _RequestAdminAccessScreenState();
}

class _RequestAdminAccessScreenState extends State<RequestAdminAccessScreen> {
  final _formKey = GlobalKey<FormState>();
  String? reason;

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = FirebaseAuth.instance.currentUser;

      // Add request to Firestore
      await FirebaseFirestore.instance.collection('admin_access_requests').add({
        'email': user?.email,
        'user_id': user?.uid,
        'reason': reason,
        'status': 'pending',
        'requested_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Request submitted successfully!'),
      ));

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Admin Access'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Reason for requesting admin access'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason';
                  }
                  return null;
                },
                onSaved: (value) {
                  reason = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRequest,
                child: Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
