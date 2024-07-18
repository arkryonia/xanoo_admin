import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/common/entities/author.dart';

abstract interface class AuthorRepository {
  // Fetch all
  Future<Either<Failure, List<Author>>> fetchAll();

  // Create
  Future<Either<Failure, Author>> create({
    required String gender,
    required String firstName,
    required String lastName,
  });

  // Read
  Future<Either<Failure, Author>> read({required String id});

  // Update
  Future<Either<Failure, Author>> update({
    required String id,
    required Author author,
  });

  // Delete
  Future<Either<Failure, void>> delete({required String id});
}
