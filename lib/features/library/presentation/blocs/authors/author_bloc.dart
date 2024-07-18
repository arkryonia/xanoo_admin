import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xanoo_admin/core/common/entities/author.dart';
import 'package:xanoo_admin/core/helpers/author_params.dart';
import 'package:xanoo_admin/core/helpers/no_params.dart';
import 'package:xanoo_admin/features/library/domain/usecases/create_author.dart';
import 'package:xanoo_admin/features/library/domain/usecases/delete_author.dart';
import 'package:xanoo_admin/features/library/domain/usecases/fetch_all_authors.dart';

part 'author_event.dart';
part 'author_state.dart';

class AuthorBloc extends Bloc<AuthorEvent, AuthorState> {
  final FetchAllAuthors _fetchAllAuthors;
  final DeleteAuthor _deleteAuthor;
  final CreateAuthor _createAuthor;

  AuthorBloc({
    required FetchAllAuthors fetchAllAuthors,
    required DeleteAuthor deleteAuthor,
    required CreateAuthor createAuthor,
  })  : _fetchAllAuthors = fetchAllAuthors,
        _deleteAuthor = deleteAuthor,
        _createAuthor = createAuthor,
        super(AuthorInitial()) {
    on<AuthorEvent>((_, emit) => emit(AuthorLoading()));
    on<AuthorFetchAll>(_onAuthorFetchAll);
    on<AuthorDelete>(_onAuthorDelete);
    on<AuthorCreate>(_onAuthorCreate);
  }

  Future<FutureOr<void>> _onAuthorCreate(
    AuthorCreate event,
    Emitter<AuthorState> emit,
  ) async {
    final response = await _createAuthor(
      AuthorParams(
        gender: event.gender,
        firstName: event.firstName,
        lastName: event.lastName,
      ),
    );

    response.fold(
      (error) => emit(AuthorFailure(error.message)),
      (author) => emit(AuthorSuccess()),
    );
  }

  Future<FutureOr<void>> _onAuthorDelete(
    AuthorDelete event,
    Emitter<AuthorState> emit,
  ) async {
    final response = await _deleteAuthor(AuthorDeleteParams(id: event.id));
    response.fold(
      (error) => emit(AuthorFailure(error.message)),
      (success) => emit(AuthorSuccess()),
    );
  }

  Future<FutureOr<void>> _onAuthorFetchAll(
    AuthorFetchAll event,
    Emitter<AuthorState> emit,
  ) async {
    final response = await _fetchAllAuthors(NoParams());
    response.fold(
      (error) => emit(AuthorFailure(error.message)),
      (authors) => emit(AuthorFecthAllSuccess(authors)),
    );
  }
}
