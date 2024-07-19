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
import 'package:xanoo_admin/features/library/data/datasources/author_supabase_d_s.dart';
import 'package:xanoo_admin/features/library/data/repositories/author_repository_impl.dart';
import 'package:xanoo_admin/features/library/domain/repositories/author_repository.dart';
import 'package:xanoo_admin/features/library/domain/usecases/create_author.dart';
import 'package:xanoo_admin/features/library/domain/usecases/delete_author.dart';
import 'package:xanoo_admin/features/library/domain/usecases/fetch_all_authors.dart';
import 'package:xanoo_admin/features/library/domain/usecases/read_author.dart';
import 'package:xanoo_admin/features/library/domain/usecases/update_author.dart';
import 'package:xanoo_admin/features/library/presentation/blocs/authors/author_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _iniLibrary();

  final supabase = await Supabase.initialize(
    url: Secret.supabaseUrl,
    anonKey: Secret.supabaseAnonKey,
  );

  sl.registerLazySingleton(() => supabase.client);

  // Core
  sl.registerLazySingleton(() => AppUserCubit());
}

void _iniLibrary() {
  sl
    // Datasources
    ..registerLazySingleton<AuthorSupabaseDS>(() => AuthorSupabaseDSImpl(sl()))

    // Repositories
    ..registerFactory<AuthorRepository>(() => AuthorRepositoryImpl(sl()))

    //Usecases
    ..registerFactory(() => FetchAllAuthors(sl()))
    ..registerFactory(() => DeleteAuthor(sl()))
    ..registerFactory(() => CreateAuthor(sl()))
    ..registerFactory(() => ReadAuthor(sl()))
    ..registerFactory(() => UpdateAuthor(sl()))

    // Blocs
    ..registerLazySingleton(
      () => AuthorBloc(
        fetchAllAuthors: sl(),
        deleteAuthor: sl(),
        createAuthor: sl(),
        readAuthor: sl(),
        updateAuthor: sl(),
      ),
    );
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
