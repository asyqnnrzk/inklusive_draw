import 'package:InklusiveDraw/source/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceList extends StatelessWidget {
  const ResourceList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('resources').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return Center(child: Text('No resources available'));
        }

        final resources = snapshot.data!.docs;

        return ListView.builder(
          itemCount: resources.length,
          itemBuilder: (context, index) {
            final resource = resources[index];
            return Column(
              children: [
                ListTile(
                  leading: Image.asset(
                    onBoardImage1,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    resource['link'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    resource['material'],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Divider(),
              ],
            );
          },
        );
      },
    );
  }
}
