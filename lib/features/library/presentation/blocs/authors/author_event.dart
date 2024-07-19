part of 'author_bloc.dart';

@immutable
sealed class AuthorEvent {}

final class AuthorFetchAll extends AuthorEvent {}

final class AuthorGetOne extends AuthorEvent {
  final String id;

  AuthorGetOne(this.id);
}

final class AuthorCreate extends AuthorEvent {
  final String gender;
  final String firstName;
  final String lastName;

  AuthorCreate(this.gender, this.firstName, this.lastName);
}

final class AuthorDelete extends AuthorEvent {
  final String id;

  AuthorDelete(this.id);
}

final class AuthorUpdate extends AuthorEvent {
  final Author author;

  AuthorUpdate({
    required this.author,
  });
}
