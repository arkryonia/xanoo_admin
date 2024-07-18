part of 'author_bloc.dart';

@immutable
sealed class AuthorEvent {}

final class AuthorFetchAll extends AuthorEvent {}
