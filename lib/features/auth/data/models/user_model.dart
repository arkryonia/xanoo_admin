import 'dart:convert';

import 'package:xanoo_admin/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.password,
    required super.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}
