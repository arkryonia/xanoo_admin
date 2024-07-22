import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xanoo_admin/core/helpers/no_params.dart';
import 'package:xanoo_admin/features/library/domain/entities/document.dart';
import 'package:xanoo_admin/features/library/domain/usecases/create_document.dart';
import 'package:xanoo_admin/features/library/domain/usecases/fetch_all_documents.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final CreateDocument _createDocument;
  final FetchAllDocuments _fetchAllDocuments;

  DocumentBloc({
    required CreateDocument createDocument,
    required FetchAllDocuments fetchAllDocuments,
  })  : _createDocument = createDocument,
        _fetchAllDocuments = fetchAllDocuments,
        super(DocumentInitial()) {
    on<DocumentEvent>((_, emit) => emit(DocumentLoading()));
    on<DocumentCreate>(_onDocumentCreate);
    on<DocumentFetchAll>(_onDocumentFetchAll);
  }

  Future<FutureOr<void>> _onDocumentFetchAll(
    DocumentFetchAll event,
    Emitter<DocumentState> emit,
  ) async {
    final response = await _fetchAllDocuments(NoParams());
    response.fold(
      (error) => emit(DocumentFailure(error.message)),
      (documents) => emit(DocumentFetchAllSuccess(documents)),
    );
  }

  Future<FutureOr<void>> _onDocumentCreate(
      DocumentCreate event, Emitter<DocumentState> emit) async {
    final response = await _createDocument(
      DocumentParams(
        title: event.title,
        description: event.description,
        nature: event.nature,
        file: event.file,
        cover: event.cover,
        authors: event.authors,
        tags: event.tags,
      ),
    );

    response.fold(
      (error) => emit(DocumentFailure(error.message)),
      (document) => emit(DocumentSuccess()),
    );
  }
}
