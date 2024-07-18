import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/helpers/user_params.dart';
import 'package:xanoo_admin/core/usecases/use_case.dart';
import 'package:xanoo_admin/core/common/entities/user.dart';
import 'package:xanoo_admin/features/auth/domain/repositories/auth_repository.dart';

class LoginUser implements UseCase<User, UserParams> {
  final AuthRepository authRepository;

  LoginUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserParams params) async {
    return await authRepository.login(
      email: params.email,
      password: params.password,
    );
  }
}
