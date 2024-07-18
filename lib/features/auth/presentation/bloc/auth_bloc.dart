import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xanoo_admin/core/common/cubit/app_user_cubit.dart';
import 'package:xanoo_admin/core/helpers/no_params.dart';
import 'package:xanoo_admin/core/helpers/user_params.dart';
import 'package:xanoo_admin/features/auth/domain/usecases/get_current_user.dart';
import 'package:xanoo_admin/features/auth/domain/usecases/login_user.dart';
import 'package:xanoo_admin/features/auth/domain/usecases/logout_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser _loginUser;
  final LogoutUser _logoutUser;
  final GetCurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required LoginUser loginUser,
    required LogoutUser logoutUser,
    required GetCurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _loginUser = loginUser,
        _logoutUser = logoutUser,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthLogin>(_onAuthLogin);
    on<AuthLogout>(_onAuthLogout);
    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
  }

  Future<FutureOr<void>> _onAuthIsUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _currentUser(NoParams());
    response.fold(
      (error) => emit(AuthFailure(error.message)),
      (user) {
        _appUserCubit.updateUser(user);
        return emit(AuthSuccess());
      },
    );
  }

  Future<FutureOr<void>> _onAuthLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _logoutUser(NoParams());
      response.fold(
        (error) => emit(AuthFailure(error.message)),
        (success) => emit(AuthInitial()),
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<FutureOr<void>> _onAuthLogin(
      AuthLogin event, Emitter<AuthState> emit) async {
    try {
      final response = await _loginUser(event.params);
      response.fold(
        (error) => emit(AuthFailure(error.message)),
        (success) => emit(AuthSuccess()),
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
