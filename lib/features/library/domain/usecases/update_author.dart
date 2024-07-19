import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/usecases/use_case.dart';
import 'package:xanoo_admin/core/common/entities/author.dart';
import 'package:xanoo_admin/features/library/domain/repositories/author_repository.dart';

class UpdateAuthor implements UseCase<Author, AuthorUpdateParams> {
  final AuthorRepository authorRepository;

  UpdateAuthor(this.authorRepository);

  @override
  Future<Either<Failure, Author>> call(AuthorUpdateParams params) {
    return authorRepository.update(
      author: params.author,
    );
  }
}

class AuthorUpdateParams {
  final Author author;

  AuthorUpdateParams({
    required this.author,
  });
}
