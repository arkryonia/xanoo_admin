import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/helpers/no_params.dart';
import 'package:xanoo_admin/core/usecases/use_case.dart';
import 'package:xanoo_admin/features/authors/domain/entities/author.dart';
import 'package:xanoo_admin/features/authors/domain/repositories/author_repository.dart';

class FetchAllAuthors implements UseCase<List<Author>, NoParams> {
  final AuthorRepository authorRepository;

  FetchAllAuthors(this.authorRepository);

  @override
  Future<Either<Failure, List<Author>>> call(NoParams params) async {
    return await authorRepository.fetchAll();
  }
}
