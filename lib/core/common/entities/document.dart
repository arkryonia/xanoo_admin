import 'package:equatable/equatable.dart';

class Document extends Equatable {
  final String id;
  final String title;
  final String description;
  final String nature;
  final String language;
  final String filePath;
  final String coverPath;
  final List<String> authors;
  final List<String> tags;

  const Document({
    required this.id,
    required this.title,
    required this.description,
    required this.nature,
    required this.language,
    required this.filePath,
    required this.coverPath,
    required this.authors,
    required this.tags,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        nature,
        language,
        filePath,
        coverPath,
        authors,
        tags,
      ];
}
