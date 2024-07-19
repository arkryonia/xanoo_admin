part of 'author_bloc.dart';

@immutable
sealed class AuthorState {}

final class AuthorInitial extends AuthorState {}

final class AuthorLoading extends AuthorState {}

final class AuthorSuccess extends AuthorState {}

final class AuthorFecthAllSuccess extends AuthorState {
  final List<Author> authors;

  AuthorFecthAllSuccess(this.authors);
}

final class AuthorGetOneSuccess extends AuthorState {
  final Author author;

  AuthorGetOneSuccess(this.author);
}

final class AuthorFailure extends AuthorState {
  final String message;

  AuthorFailure(this.message);
}
