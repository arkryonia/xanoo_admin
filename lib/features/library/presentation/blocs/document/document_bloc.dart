import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xanoo_admin/features/library/domain/usecases/create_document.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final CreateDocument _createDocument;

  DocumentBloc({required CreateDocument createDocument})
      : _createDocument = createDocument,
        super(DocumentInitial()) {
    on<DocumentEvent>((_, emit) => emit(DocumentLoading()));
    on<DocumentCreate>(_onDocumentCreate);
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
