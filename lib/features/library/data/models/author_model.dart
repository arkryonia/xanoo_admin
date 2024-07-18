import 'dart:convert';

import 'package:xanoo_admin/core/common/entities/author.dart';

class AuthorModel extends Author {
  AuthorModel({
    required super.id,
    required super.gender,
    required super.firstName,
    required super.lastName,
  });

  AuthorModel copyWith({
    String? id,
    String? gender,
    String? firstName,
    String? lastName,
  }) {
    return AuthorModel(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gender': gender,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  factory AuthorModel.fromMap(Map<String, dynamic> map) {
    return AuthorModel(
      id: map['id'] ?? '',
      gender: map['gender'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthorModel.fromJson(String source) =>
      AuthorModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AuthorModel(id: $id, gender: $gender, firstName: $firstName, lastName: $lastName)';
  }
}
