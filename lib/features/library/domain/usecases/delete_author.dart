import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/usecases/use_case.dart';
import 'package:xanoo_admin/features/library/domain/repositories/author_repository.dart';

class DeleteAuthor implements UseCase<void, AuthorDeleteParams> {
  final AuthorRepository authorRepository;

  DeleteAuthor(this.authorRepository);

  @override
  Future<Either<Failure, void>> call(AuthorDeleteParams params) async {
    return await authorRepository.delete(id: params.id);
  }
}

class AuthorDeleteParams {
  final String id;

  AuthorDeleteParams({required this.id});
}
