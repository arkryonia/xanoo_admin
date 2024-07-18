import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/helpers/author_params.dart';
import 'package:xanoo_admin/core/usecases/use_case.dart';
import 'package:xanoo_admin/core/common/entities/author.dart';
import 'package:xanoo_admin/features/library/domain/repositories/author_repository.dart';

class CreateAuthor implements UseCase<Author, AuthorParams> {
  final AuthorRepository authorRepository;

  CreateAuthor(this.authorRepository);

  @override
  Future<Either<Failure, Author>> call(AuthorParams params) async {
    return await authorRepository.create(
      gender: params.gender,
      firstName: params.firstName,
      lastName: params.lastName,
    );
  }
}
