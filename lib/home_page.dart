import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:xanoo_admin/core/app/app_constants.dart';
import 'package:xanoo_admin/features/auth/presentation/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "xDashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          const Text("Acteurs"),
          const Gap(20),
          const Text("Document"),
          const Gap(20),
          const Text("Profile"),
          const Gap(20),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
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
  }
}
