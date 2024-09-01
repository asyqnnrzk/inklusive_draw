import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportButton extends StatefulWidget {
  final TextStyle? buttonStyle;
  final TextStyle? dialogTitleStyle;
  final TextStyle? dialogContentStyle;
  final String postId;
  final String userId;

  const ReportButton({
    Key? key,
    this.buttonStyle,
    this.dialogTitleStyle,
    this.dialogContentStyle,
    required this.postId,
    required this.userId,
  }) : super(key: key);

  @override
  _ReportButtonState createState() => _ReportButtonState();
}

class _ReportButtonState extends State<ReportButton> {
  final TextEditingController _reasonController = TextEditingController();

  Future<void> _submitReport() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('reports').add({
        'userIdReporting': user!.uid,
        'userIdReported': widget.userId,
        'reason': _reasonController.text,
        'timestamp': Timestamp.now(),
        'status': 'pending',
        'postId': widget.postId,
        'isDeleted': false,
      });

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              'We will review your report, thank you!',
              style: LightTextTheme.reportDetails,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Close',
                  style: LightTextTheme.submitBtn,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              'Failed to submit report, please try again later',
              style: LightTextTheme.reportDetails,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Close',
                  style: LightTextTheme.submitBtn,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.report_outlined),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Report!',
                style: LightTextTheme.reportBtn,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _reasonController,
                    decoration: InputDecoration(
                      labelText: 'Reason for reporting',
                      labelStyle: LightTextTheme.reportDetails,
                      hintText: 'Enter reason here',
                      hintStyle: LightTextTheme.reportDetails,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _submitReport();
                    },
                    child: Text(
                      'Submit',
                      style: LightTextTheme.submitBtn,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}