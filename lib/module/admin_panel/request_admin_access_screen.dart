import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../source/colors.dart';
import '../../source/text_theme.dart';

class RequestAdminAccessScreen extends StatefulWidget {
  @override
  _RequestAdminAccessScreenState createState() =>
      _RequestAdminAccessScreenState();
}

class _RequestAdminAccessScreenState extends State<RequestAdminAccessScreen> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? email;
  String? reason;

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Add request to Firestore
      await FirebaseFirestore.instance.collection('admin_access_requests')
          .add({
        'username': username,
        'email': email,
        'reason': reason,
        'status': 'pending',
        'requested_at': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        '',
        '',
        titleText: Text(
          'Request Sent!',
          style: LightTextTheme.snackbarBold,
        ),
        messageText: Text(
          'We will review your request',
          style: LightTextTheme.snackbarTxt,
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: greenButton,
        colorText: blackColor,
      );

      Navigator.of(context).pop();
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
          'Request Admin',
          style: LightTextTheme.pageHeadline,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: LightTextTheme.tfName,
                      errorStyle: LightTextTheme.tfError
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: LightTextTheme.tfName,
                      errorStyle: LightTextTheme.tfError
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Reason for requesting',
                    labelStyle: LightTextTheme.tfName,
                    errorStyle: LightTextTheme.tfError
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your reason';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    reason = value;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitRequest,
                  child: Text(
                    'Submit Request',
                    style: LightTextTheme.yesBtn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
