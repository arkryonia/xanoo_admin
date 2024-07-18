import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xanoo_admin/core/common/entities/author.dart';
import 'package:xanoo_admin/core/helpers/no_params.dart';
import 'package:xanoo_admin/features/library/domain/usecases/fetch_all_authors.dart';

part 'author_event.dart';
part 'author_state.dart';

class AuthorBloc extends Bloc<AuthorEvent, AuthorState> {
  final FetchAllAuthors _fetchAllAuthors;

  AuthorBloc({required FetchAllAuthors fetchAllAuthors})
      : _fetchAllAuthors = fetchAllAuthors,
        super(AuthorInitial()) {
    on<AuthorEvent>((_, emit) => emit(AuthorLoading()));
    on<AuthorFetchAll>(_onAuthorFetchAll);
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
