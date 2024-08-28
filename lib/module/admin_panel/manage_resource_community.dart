import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void addResource(BuildContext context) async {
  TextEditingController creatorController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController materialController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Add New Resource',
          style: LightTextTheme.dashboardTxtBold,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: creatorController,
                decoration: InputDecoration(
                  labelText: 'YouTube Creator',
                  labelStyle: LightTextTheme.dashboardTxt
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: linkController,
                decoration: InputDecoration(
                  labelText: 'YouTube Link',
                  labelStyle: LightTextTheme.dashboardTxt
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: materialController,
                decoration: InputDecoration(
                  labelText: 'Video Name',
                  labelStyle: LightTextTheme.dashboardTxt
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: LightTextTheme.cancelBtn,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Get input values
              String creator = creatorController.text.trim();
              String link = linkController.text.trim();
              String material = materialController.text.trim();

              if (creator.isNotEmpty && link.isNotEmpty && material
                  .isNotEmpty) {
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Confirmation!',
                        style: LightTextTheme.reportBtn,
                      ),
                      content: Text(
                        'Add this resource?',
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
                            Navigator.pop(context, true);
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

                if (confirm == true) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('resources')
                        .add({
                      'creator': creator,
                      'link': link,
                      'material': material,
                    });
                    print('Resource added successfully');
                    Navigator.pop(context);
                    // Show resource added confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Done!',
                            style: LightTextTheme.cancelBtn,
                          ),
                          content: Text(
                            'New resource has been added',
                            style: LightTextTheme.reportDetails,
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'OK',
                                style: LightTextTheme.cancelBtn,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    print('Error adding resource: $e');
                  }
                }
              } else {
                // Show error dialog for empty fields
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Empty Field',
                        style: LightTextTheme.reportBtn,
                      ),
                      content: Text(
                        'Please fill in all fields',
                        style: LightTextTheme.reportDetails,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'OK',
                            style: LightTextTheme.cancelBtn,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text(
              'Add',
              style: LightTextTheme.yesBtn,
            ),
          ),
        ],
      );
    },
  );
}

void addCommunity(BuildContext context) async {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Add New Community',
          style: LightTextTheme.dashboardTxtBold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Community Name',
                labelStyle: LightTextTheme.dashboardTxt
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: LightTextTheme.dashboardTxt
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: LightTextTheme.cancelBtn,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Get input values
              String name = nameController.text.trim();
              String description = descriptionController.text.trim();

              if (name.isNotEmpty && description.isNotEmpty) {
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Confirmation!',
                        style: LightTextTheme.reportBtn,
                      ),
                      content: Text(
                        'Add this resource?',
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
                            Navigator.pop(context, true);
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

                if (confirm == true) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('communities')
                        .add({
                      'name': name,
                      'description': description,
                    });
                    print('New community added successfully');
                    Navigator.pop(context);

                    // Show resource added confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Done!',
                            style: LightTextTheme.cancelBtn,
                          ),
                          content: Text(
                            'New community has been added',
                            style: LightTextTheme.reportDetails,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'OK',
                                style: LightTextTheme.cancelBtn,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    print('Error adding community: $e');
                  }
                }
              } else {
                // Show error dialog for empty fields
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Empty Field',
                        style: LightTextTheme.reportBtn,
                      ),
                      content: Text(
                        'Please fill in all fields',
                        style: LightTextTheme.reportDetails,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'OK',
                            style: LightTextTheme.cancelBtn,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text(
              'Add',
              style: LightTextTheme.yesBtn,
            ),
          ),
        ],
      );
    },
  );
}

void deleteResource(BuildContext context) async {

}

void deleteCommunity(BuildContext context) async {

}