part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLogin extends AuthEvent {
  final UserParams params;

  AuthLogin(this.params);
}

class AuthLogout extends AuthEvent {}
