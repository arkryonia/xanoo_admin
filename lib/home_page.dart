import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:xanoo_admin/core/widgets/loading_widget.dart';
import 'package:xanoo_admin/core/widgets/widget_helpers.dart';
import 'package:xanoo_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:xanoo_admin/features/auth/presentation/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static MaterialPageRoute goToLogin() {
    return MaterialPageRoute(
      builder: (context) => const LoginPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushReplacement(context, HomePage.goToLogin());
        }

        if (state is AuthFailure) {
          showSnakeBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const LoadingWidget();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "xDashboard",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              const Text("Document"),
              const Gap(20),
              IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogout());
                },
                icon: const Icon(Icons.exit_to_app),
              ),
              const Gap(20),
            ],
          ),
          body: const Center(
            child: Text('Home Page : Dashboard'),
          ),
        );
      },
    );
  }
}
