import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/helpers/no_params.dart';
import 'package:xanoo_admin/core/usecases/use_case.dart';
import 'package:xanoo_admin/features/library/domain/entities/document.dart';
import 'package:xanoo_admin/features/library/domain/repositories/document_repository.dart';

class FetchAllDocuments implements UseCase<List<Document>, NoParams> {
  final DocumentRepository documentRepository;

  FetchAllDocuments(this.documentRepository);

  @override
  Future<Either<Failure, List<Document>>> call(NoParams params) async {
    return await documentRepository.fetchAll();
  }
}
