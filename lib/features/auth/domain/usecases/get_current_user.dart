import 'package:fpdart/fpdart.dart';
import 'package:xanoo_admin/core/error/failure.dart';
import 'package:xanoo_admin/core/helpers/no_params.dart';
import 'package:xanoo_admin/core/usecases/use_case.dart';
import 'package:xanoo_admin/features/auth/domain/entities/user.dart';
import 'package:xanoo_admin/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  GetCurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.getCurrentUser();
  }
}
