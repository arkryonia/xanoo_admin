import 'dart:convert';

import 'package:xanoo_admin/features/library/domain/entities/document.dart';

class DocumentModel extends Document {
  DocumentModel({
    required super.id,
    required super.title,
    required super.description,
    required super.nature,
    required super.filePath,
    required super.coverPath,
    required super.authors,
    required super.tags,
  });

  DocumentModel copyWith({
    String? id,
    String? title,
    String? description,
    String? nature,
    String? filePath,
    String? coverPath,
    List<String>? authors,
    List<String>? tags,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      nature: nature ?? this.nature,
      filePath: filePath ?? this.filePath,
      coverPath: coverPath ?? this.coverPath,
      authors: authors ?? this.authors,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'nature': nature,
      'file_url': filePath,
      'cover_url': coverPath,
      'authors': authors,
      'tags': tags,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      nature: map['nature'] ?? '',
      filePath: map['file_url'] ?? '',
      coverPath: map['cover_url'] ?? '',
      authors: (map['authors'] as List<dynamic>?)?.cast<String>() ?? [],
      tags: (map['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source));
}
