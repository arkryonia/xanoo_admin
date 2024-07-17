import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xanoo_admin/core/app/secret.dart';
import 'package:xanoo_admin/core/common/cubit/app_user_cubit.dart';
import 'package:xanoo_admin/features/auth/data/datasources/auth_supabase.dart';
import 'package:xanoo_admin/features/auth/data/repositories/auth_repositrory_impl.dart';
import 'package:xanoo_admin/features/auth/domain/repositories/auth_repository.dart';
import 'package:xanoo_admin/features/auth/domain/usecases/get_current_user.dart';
import 'package:xanoo_admin/features/auth/domain/usecases/login_user.dart';
import 'package:xanoo_admin/features/auth/domain/usecases/logout_user.dart';
import 'package:xanoo_admin/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();

  final supabase = await Supabase.initialize(
    url: Secret.supabaseUrl,
    anonKey: Secret.supabaseAnonKey,
  );

  sl.registerLazySingleton(() => supabase.client);

  // Core
  sl.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  sl
    // Datasource
    ..registerFactory<AuthSupabase>(() => AuthSupabaseImpl(sl()))

    // Repository
    ..registerFactory<AuthRepository>(() => AuthRepositroryImpl(sl()))

    // Usecases
    ..registerFactory(() => LoginUser(sl()))
    ..registerFactory(() => LogoutUser(sl()))
    ..registerFactory(() => GetCurrentUser(sl()))

    // Blocs
    ..registerLazySingleton(
      () => AuthBloc(
        loginUser: sl(),
        logoutUser: sl(),
        currentUser: sl(),
        appUserCubit: sl(),
      ),
    );
}
