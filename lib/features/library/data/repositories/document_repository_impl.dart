import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/error/server_exception.dart';
import 'package:xanoo_admin/features/library/data/datasources/document_supabase_d_s.dart';
import 'package:xanoo_admin/features/library/data/models/document_model.dart';
import 'package:xanoo_admin/core/common/entities/document.dart';
import 'package:xanoo_admin/features/library/domain/repositories/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentSupabaseDS documentSupabaseDS;

  DocumentRepositoryImpl(this.documentSupabaseDS);

  @override
  Future<Either<Failure, Document>> create({
    required String title,
    required String description,
    required String nature,
    required File file,
    required File cover,
    required List<String> authors,
    required List<String> tags,
  }) async {
    try {
      DocumentModel document = DocumentModel(
        id: const Uuid().v4(),
        title: title,
        description: description,
        nature: nature,
        filePath: '',
        coverPath: '',
        authors: authors,
        tags: tags,
      );

      final filePath = await documentSupabaseDS.uploadAsset(
        asset: file,
        document: document,
      );
      final coverPath = await documentSupabaseDS.uploadAsset(
        asset: cover,
        document: document,
        isCover: true,
      );

      document = document.copyWith(
        filePath: filePath,
        coverPath: coverPath,
      );

      final response = await documentSupabaseDS.create(document: document);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Document>>> fetchAll() async {
    try {
      final response = await documentSupabaseDS.fetchAll();
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> delete({required String id}) async {
    try {
      await documentSupabaseDS.delete(id: id);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
