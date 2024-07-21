import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/features/library/domain/entities/document.dart';

abstract interface class DocumentRepository {
  Future<Either<Failure, List<Document>>> fetchAll();
  Future<Either<Failure, void>> create({
    required String title,
    required String description,
    required String nature,
    required File file,
    required File cover,
    required List<String> authors,
    required List<String> tags,
  });
}
