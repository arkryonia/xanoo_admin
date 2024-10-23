import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/usecases/use_case.dart';
import 'package:xanoo_admin/core/common/entities/document.dart';
import 'package:xanoo_admin/features/library/domain/repositories/document_repository.dart';

class CreateDocument implements UseCase<void, DocumentParams> {
  final DocumentRepository documentRepository;

  CreateDocument(this.documentRepository);

  @override
  Future<Either<Failure, Document>> call(DocumentParams params) async {
    return await documentRepository.create(
      title: params.title,
      description: params.description,
      nature: params.nature,
      language: params.language,
      file: params.file,
      cover: params.cover,
      authors: params.authors,
      tags: params.tags,
    );
  }
}

class DocumentParams {
  final String title;
  final String description;
  final String nature;
  final String language;
  final File file;
  final File cover;
  final List<String> authors;
  final List<String> tags;

  DocumentParams({
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
