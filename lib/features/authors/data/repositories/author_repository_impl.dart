import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/error/server_exception.dart';
import 'package:xanoo_admin/features/authors/data/datasources/author_supabase_d_s.dart';
import 'package:xanoo_admin/features/authors/data/models/author_model.dart';
import 'package:xanoo_admin/features/authors/domain/entities/author.dart';
import 'package:xanoo_admin/features/authors/domain/repositories/author_repository.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final AuthorSupabaseDS authorSupabaseDS;

  AuthorRepositoryImpl(this.authorSupabaseDS);

  @override
  Future<Either<Failure, Author>> create({
    required String gender,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await authorSupabaseDS.create(
        gender: gender,
        firstName: firstName,
        lastName: lastName,
      );
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> delete({required String id}) async {
    try {
      await authorSupabaseDS.delete(id: id);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Author>>> fetchAll() async {
    try {
      final response = await authorSupabaseDS.fetchAll();
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Author>> read({required String id}) async {
    try {
      final response = await authorSupabaseDS.read(id: id);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Author>> update({
    required String id,
    required Author author,
  }) async {
    try {
      final response =
          await authorSupabaseDS.update(id: id, author: author as AuthorModel);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
