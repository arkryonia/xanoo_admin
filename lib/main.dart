import 'package:flutter/material.dart';
import 'package:xanoo_admin/core/app/app_theme.dart';
import 'package:xanoo_admin/features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      home: const LoginPage(),
    );
  }
}
