import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xanoo_admin/core/app/app_theme.dart';
import 'package:xanoo_admin/core/common/cubit/app_user_cubit.dart';
import 'package:xanoo_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:xanoo_admin/features/auth/presentation/pages/login_page.dart';
import 'package:xanoo_admin/features/library/presentation/blocs/authors/author_bloc.dart';
import 'package:xanoo_admin/features/library/presentation/blocs/document/document_bloc.dart';
import 'package:xanoo_admin/home_page.dart';
import 'package:xanoo_admin/init_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppUserCubit(),
        ),
        BlocProvider(
          create: (_) => AuthBloc(
            loginUser: sl(),
            logoutUser: sl(),
            appUserCubit: sl(),
            currentUser: sl(),
          ),
        ),
        BlocProvider(
          create: (_) => AuthorBloc(
            fetchAllAuthors: sl(),
            deleteAuthor: sl(),
            createAuthor: sl(),
            readAuthor: sl(),
            updateAuthor: sl(),
          ),
        ),
        BlocProvider(
          create: (_) => DocumentBloc(
            createDocument: sl(),
            fetchAllDocuments: sl(),
            deleteDocument: sl(),
          ),
        ),
      ],
      child: const Xanoo(),
    ),
  );
}

class Xanoo extends StatefulWidget {
  const Xanoo({super.key});

  @override
  State<Xanoo> createState() => _XanooState();
}

class _XanooState extends State<Xanoo> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      home: BlocSelector<AuthBloc, AuthState, bool>(
        selector: (state) {
          return state is AuthIsUserLoggedIn;
        },
        builder: (context, isUserLogin) {
          return isUserLogin ? const HomePage() : const LoginPage();
        },
      ),
    );
  }
}
