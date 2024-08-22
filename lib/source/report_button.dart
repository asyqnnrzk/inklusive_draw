import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  final TextStyle? buttonStyle;
  final TextStyle? dialogTitleStyle;
  final TextStyle? dialogContentStyle;

  const ReportButton({
    Key? key,
    this.buttonStyle,
    this.dialogTitleStyle,
    this.dialogContentStyle,
  }) : super(key: key);

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
                style: LightTextTheme.reportDetails,
              ),
              content: Column(
                mainAxisSize: MainAxisSize
                    .min,
                children: <Widget>[
                  TextField(
                    decoration:
                    InputDecoration(
                        labelText: 'Reason for reporting',
                        labelStyle: LightTextTheme.reportDetails,
                        hintText: 'Enter reason here',
                        hintStyle: LightTextTheme.reportDetails
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text('We will review your report, '
                                'thank you!',
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
}
