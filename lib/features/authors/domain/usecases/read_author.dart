import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/usecases/use_case.dart';
import 'package:xanoo_admin/features/authors/domain/entities/author.dart';
import 'package:xanoo_admin/features/authors/domain/repositories/author_repository.dart';

class ReadAuthor implements UseCase<Author, AuthorReadParams> {
  final AuthorRepository authorRepository;

  ReadAuthor(this.authorRepository);

  @override
  Future<Either<Failure, Author>> call(AuthorReadParams params) async {
    return await authorRepository.read(id: params.id);
  }
}

class AuthorReadParams {
  final String id;

  AuthorReadParams({required this.id});
}
