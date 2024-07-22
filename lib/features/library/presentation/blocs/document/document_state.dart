part of 'document_bloc.dart';

@immutable
sealed class DocumentState {}

final class DocumentInitial extends DocumentState {}

final class DocumentLoading extends DocumentState {}

final class DocumentFailure extends DocumentState {
  final String message;

  DocumentFailure(this.message);
}

final class DocumentSuccess extends DocumentState {}

final class DocumentFetchAllSuccess extends DocumentState {
  // TODO: Refactor Document Entity
  final List<Document> documents;

  DocumentFetchAllSuccess(this.documents);
}
