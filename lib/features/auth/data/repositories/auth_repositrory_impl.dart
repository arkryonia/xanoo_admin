import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/error/server_exception.dart';
import 'package:xanoo_admin/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:xanoo_admin/features/auth/domain/entities/user.dart';
import 'package:xanoo_admin/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositroryImpl implements AuthRepository {
  final AuthSupabase authRemoteDatasouce;

  AuthRepositroryImpl(this.authRemoteDatasouce);

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      var response = await authRemoteDatasouce.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authRemoteDatasouce.signOut();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}