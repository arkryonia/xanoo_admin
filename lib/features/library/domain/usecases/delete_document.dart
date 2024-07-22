import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/usecases/use_case.dart';
import 'package:xanoo_admin/features/library/domain/repositories/document_repository.dart';

class DeleteDocument implements UseCase<void, DeleteDocumentParams> {
  final DocumentRepository documentRepository;

  DeleteDocument(this.documentRepository);

  @override
  Future<Either<Failure, void>> call(DeleteDocumentParams params) async {
    return await documentRepository.delete(id: params.id);
  }
}

class DeleteDocumentParams {
  final String id;

  DeleteDocumentParams({required this.id});
}
