class Document {
  final String id;
  final String title;
  final String description;
  final String nature;
  final String filePath; // Changed from File to String
  final String coverPath; // Changed from File to String
  final List<String> authors;
  final List<String> tags;

  Document({
    required this.id,
    required this.title,
    required this.description,
    required this.nature,
    required this.filePath,
    required this.coverPath,
    required this.authors,
    required this.tags,
  });
}
