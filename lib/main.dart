import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xanoo_admin/core/app/app_theme.dart';
import 'package:xanoo_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:xanoo_admin/features/auth/presentation/pages/login_page.dart';
import 'package:xanoo_admin/init_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            loginUser: sl(),
            logoutUser: sl(),
          ),
        ),
      ],
      child: const Xanoo(),
    ),
  );
}

class Xanoo extends StatelessWidget {
  const Xanoo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      home: const LoginPage(),
    );
  }
}
