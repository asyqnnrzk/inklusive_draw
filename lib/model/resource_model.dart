import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceModel {
  final String? id;
  final String link;
  final String material;

  const ResourceModel({
    this.id,
    required this.link,
    required this.material
  });

  toJson() {
    return {
      'link': link,
      'material': material
    };
  }

  // map user fetched from firebase to UserModel
  factory ResourceModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ResourceModel(
        id: document.id,
        link: data['link'],
        material: data['material']
    );
  }
}