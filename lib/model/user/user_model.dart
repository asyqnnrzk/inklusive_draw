import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String name;
  final String username;
  final String password;
  final String plainPassword;
  final String email;

  const UserModel({
    this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.plainPassword,
    required this.email
  });

  toJson() {
    return {
      'name': name,
      'username': username,
      'password': password,
      'plain_password': plainPassword,
      'email': email
    };
  }

  // map user fetched from firebase to UserModel
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      name: data['name'],
      username: data['username'],
      password: data['password'],
      plainPassword: data['plain_password'],
      email: data['email']
    );
  }
}