part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLogin extends AuthEvent {
  final UserParams params;

  AuthLogin(this.params);
}

final class AuthLogout extends AuthEvent {}

final class AuthIsUserLoggedIn extends AuthEvent {}
