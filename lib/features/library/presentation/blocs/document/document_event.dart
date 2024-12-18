part of 'document_bloc.dart';

@immutable
sealed class DocumentEvent {}

final class DocumentCreate extends DocumentEvent {
  final String title;
  final String description;
  final String nature;
  final String language;
  final File file;
  final File cover;
  final List<String> authors;
  final List<String> tags;

  DocumentCreate({
    required this.title,
    required this.description,
    required this.nature,
    required this.language,
    required this.file,
    required this.cover,
    required this.authors,
    required this.tags,
  });
}

final class DocumentFetchAll extends DocumentEvent {}

final class DocumentDelete extends DocumentEvent {
  final String id;

  DocumentDelete(this.id);
}
