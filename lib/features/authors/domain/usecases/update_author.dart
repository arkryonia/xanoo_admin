import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/usecases/use_case.dart';
import 'package:xanoo_admin/features/authors/domain/entities/author.dart';
import 'package:xanoo_admin/features/authors/domain/repositories/author_repository.dart';

class ClassNameUpdateAuthor implements UseCase<Author, AuthorUpdateParams> {
  final AuthorRepository authorRepository;

  ClassNameUpdateAuthor(this.authorRepository);

  @override
  Future<Either<Failure, Author>> call(AuthorUpdateParams params) {
    return authorRepository.update(
      id: params.id,
      author: params.author,
    );
  }
}

class AuthorUpdateParams {
  final String id;
  final Author author;

  AuthorUpdateParams({
    required this.id,
    required this.author,
  });
}
