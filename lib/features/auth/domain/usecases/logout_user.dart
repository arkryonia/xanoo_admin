import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/helpers/no_params.dart';
import 'package:xanoo_admin/core/usecases/use_case.dart';
import 'package:xanoo_admin/features/auth/domain/repositories/auth_repository.dart';

class LogoutUser implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  LogoutUser(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.logout();
  }
}
