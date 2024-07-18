part of 'author_bloc.dart';

@immutable
sealed class AuthorEvent {}

final class AuthorFetchAll extends AuthorEvent {}

final class AuthorCreate extends AuthorEvent {}

final class AuthorDelete extends AuthorEvent {
  final String id;

  AuthorDelete(this.id);
}
