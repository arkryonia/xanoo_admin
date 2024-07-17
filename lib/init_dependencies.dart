import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xanoo_admin/core/app/secret.dart';
import 'package:xanoo_admin/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:xanoo_admin/features/auth/data/repositories/auth_repositrory_impl.dart';
import 'package:xanoo_admin/features/auth/domain/repositories/auth_repository.dart';
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

    // Blocs
    ..registerLazySingleton(
      () => AuthBloc(
        loginUser: sl(),
        logoutUser: sl(),
      ),
    );
}
