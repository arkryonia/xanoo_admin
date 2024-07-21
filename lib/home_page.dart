import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:xanoo_admin/core/widgets/loading_widget.dart';
import 'package:xanoo_admin/core/widgets/widget_helpers.dart';
import 'package:xanoo_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:xanoo_admin/features/library/presentation/pages/document_list_page.dart';
import 'package:xanoo_admin/features/auth/presentation/pages/login_page.dart';
import 'package:xanoo_admin/features/library/presentation/pages/author_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static MaterialPageRoute goToLoginPage() {
    return MaterialPageRoute(
      builder: (context) => const LoginPage(),
    );
  }

  static MaterialPageRoute goToAuthorListPage() {
    return MaterialPageRoute(
      builder: (context) => const AuthorListPage(),
    );
  }

  static MaterialPageRoute goToListDocumentsPage() {
    return MaterialPageRoute(
      builder: (context) => const ListDocumentsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushReplacement(context, HomePage.goToLoginPage());
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
              IconButton(
                onPressed: () {
                  Navigator.push(context, HomePage.goToListDocumentsPage());
                },
                icon: const Icon(Icons.auto_stories),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, HomePage.goToAuthorListPage());
                },
                icon: const Icon(Icons.group),
              ),
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
