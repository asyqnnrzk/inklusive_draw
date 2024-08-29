import 'package:InklusiveDraw/source/text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void addResource(BuildContext context) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: creatorController,
                  decoration: InputDecoration(
                    labelText: 'YouTube Creator',
                    labelStyle: LightTextTheme.dashboardTxt,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the creator\'s name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: linkController,
                  decoration: InputDecoration(
                    labelText: 'YouTube Link',
                    labelStyle: LightTextTheme.dashboardTxt,
                  ),
                  validator: (value) {
                    const pattern = r'^(https?\:\/\/)?(www\.youtube\.com|'
                        r'youtu\.?be)\/.+$';
                    final regExp = RegExp(pattern);

                    if (value == null || value.isEmpty) {
                      return 'Please enter a YouTube link';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Please enter a valid YouTube link';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: materialController,
                  decoration: InputDecoration(
                    labelText: 'Video Name',
                    labelStyle: LightTextTheme.dashboardTxt,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the video name';
                    }
                    return null;
                  },
                ),
              ],
            ),
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
              if (formKey.currentState?.validate() ?? false) {
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
                      'creator': creatorController.text.trim(),
                      'link': linkController.text.trim(),
                      'material': materialController.text.trim(),
                    });
                    print('Resource added successfully');
                    Navigator.pop(context); // Close the dialog
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
                    // Show error dialog if adding fails
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Error!',
                            style: LightTextTheme.deleteBtn,
                          ),
                          content: Text(
                            'Failed to add the resource. Please try again '
                                'later.',
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
                }
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
                        'Add this community?',
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

void deleteResource(BuildContext context, String resourceId) async {
  bool? confirm = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Confirmation!',
          style: LightTextTheme.reportBtn,
        ),
        content: Text(
          'Delete this resource?',
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
          .doc(resourceId)
          .delete();

      print('Resource deleted successfully');

      // Show resource deleted confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Done!',
              style: LightTextTheme.cancelBtn,
            ),
            content: Text(
              'The resource has been deleted',
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
      print('Error deleting resource: $e');

      // Show error dialog if deletion fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text(
              'Uh oh!',
              style: LightTextTheme.deleteBtn,
            ),
            content: Text(
              'Failed to delete the resource. Please try again later.',
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
  }
}

void deleteCommunity(BuildContext context, String communityId) async {
  bool? confirm = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Confirmation!',
          style: LightTextTheme.reportBtn,
        ),
        content: Text(
          'Delete this community?',
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
          .doc(communityId)
          .delete();

      print('Community deleted successfully');

      // Show resource deleted confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Done!',
              style: LightTextTheme.cancelBtn,
            ),
            content: Text(
              'The community has been deleted',
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
      print('Error deleting community: $e');

      // Show error dialog if deletion fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text(
              'Uh oh!',
              style: LightTextTheme.deleteBtn,
            ),
            content: Text(
              'Failed to delete the community. Please try again later.',
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
  }
}

void editResource(BuildContext context, String resourceId) async {
  // Fetch current resource data
  DocumentSnapshot resourceSnapshot = await FirebaseFirestore.instance
      .collection('resources')
      .doc(resourceId)
      .get();
  Map<String, dynamic> resourceData = resourceSnapshot.data() as Map<String,
      dynamic>;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController linkController = TextEditingController
    (text: resourceData['link']);
  TextEditingController creatorController = TextEditingController
    (text: resourceData['creator']);
  TextEditingController materialController = TextEditingController
    (text: resourceData['material']);

  bool? confirmEdit = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Edit Resource',
          style: LightTextTheme.reportBtn,
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: creatorController,
                  decoration: InputDecoration(
                    labelText: 'YouTube Creator',
                    labelStyle: LightTextTheme.dashboardTxt,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the creator\'s name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: linkController,
                  decoration: InputDecoration(
                    labelText: 'YouTube Link',
                    labelStyle: LightTextTheme.dashboardTxt,
                  ),
                  validator: (value) {
                    const pattern = r'^(https?\:\/\/)?(www\.youtube\.com|'
                        r'youtu\.?be)\/.+$';
                    final regExp = RegExp(pattern);

                    if (value == null || value.isEmpty) {
                      return 'Please enter a YouTube link';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Please enter a valid YouTube link';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: materialController,
                  decoration: InputDecoration(
                    labelText: 'Video Name',
                    labelStyle: LightTextTheme.dashboardTxt,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the video name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
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
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                bool? confirmSave = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Confirm Save',
                        style: LightTextTheme.reportBtn,
                      ),
                      content: Text(
                        'Save these changes?',
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
                            'Confirm',
                            style: LightTextTheme.yesBtn,
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirmSave == true) {
                  Navigator.pop(context, true);
                }
              }
            },
            child: Text(
              'Save',
              style: LightTextTheme.yesBtn,
            ),
          ),
        ],
      );
    },
  );

  if (confirmEdit == true) {
    try {
      // Update the resource in Firestore
      await FirebaseFirestore.instance.collection('resources')
          .doc(resourceId).update({
        'link': linkController.text.trim(),
        'creator': creatorController.text.trim(),
        'material': materialController.text.trim(),
      });

      print('Resource updated successfully');

      // Show success confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Done!',
              style: LightTextTheme.cancelBtn,
            ),
            content: Text(
              'The resource has been updated successfully',
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
      print('Error updating resource: $e');

      // Show error dialog if update fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Uh oh!',
              style: LightTextTheme.deleteBtn,
            ),
            content: Text(
              'Failed to update the resource. Please try again later.',
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
  }
}

void editCommunity(BuildContext context, String communityId) async {
  // Fetch current community data
  DocumentSnapshot communitySnapshot = await FirebaseFirestore.instance
      .collection('communities')
      .doc(communityId)
      .get();
  Map<String, dynamic> communityData = communitySnapshot.data() as Map<String,
      dynamic>;

  TextEditingController nameController = TextEditingController
    (text: communityData['name']);
  TextEditingController descriptionController = TextEditingController
    (text: communityData['description']);

  bool? confirmEdit = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Edit Community',
          style: LightTextTheme.reportBtn,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Community Name',
                  labelStyle: LightTextTheme.dashboardTxt,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: LightTextTheme.dashboardTxt,
                ),
              ),
            ],
          ),
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
            onPressed: () async {
              if (nameController.text.isEmpty ||
                  descriptionController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Empty Field',
                        style: LightTextTheme.deleteBtn,
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
              } else {
                bool? confirmSave = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Confirm Save',
                        style: LightTextTheme.reportBtn,
                      ),
                      content: Text(
                        'Save these changes?',
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
                            'Confirm',
                            style: LightTextTheme.yesBtn,
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirmSave == true) {
                  Navigator.pop(context, true);
                }
              }
            },
            child: Text(
              'Save',
              style: LightTextTheme.yesBtn,
            ),
          ),
        ],
      );
    },
  );

  if (confirmEdit == true) {
    try {
      // Update the community in Firestore
      await FirebaseFirestore.instance.collection('communities')
          .doc(communityId).update({
        'name': nameController.text,
        'description': descriptionController.text,
      });

      print('Community updated successfully');

      // Show success confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Done!',
              style: LightTextTheme.cancelBtn,
            ),
            content: Text(
              'The community has been updated successfully',
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
      print('Error updating community: $e');

      // Show error dialog if update fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Uh oh!',
              style: LightTextTheme.deleteBtn,
            ),
            content: Text(
              'Failed to update the community. Please try again later.',
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
  }
}