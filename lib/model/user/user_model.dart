import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bcrypt/bcrypt.dart';

class UserModel {
  final String? id;
  final String name;
  final String username;
  final String password;
  final String email;

  const UserModel({
    this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.email,
  });

  // Method to convert the model to JSON with hashed password
  Future<Map<String, dynamic>> toJsonWithHashedPassword() async {
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    return {
      'name': name,
      'username': username,
      'password': hashedPassword,
      'email': email,
    };
  }

  // Factory method to create a UserModel from a Firestore snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>>
  document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      name: data['name'],
      username: data['username'],
      password: data['password'],
      email: data['email'],
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? username,
    String? password,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }
}
