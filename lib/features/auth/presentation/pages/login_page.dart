import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:xanoo_admin/core/widgets/x_green_elevated_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 350,
          vertical: 50,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.asset('assets/svg/welcome.svg', height: 250),
              const TitleWidget(title: 'BIENVENUE SUR xDASHBOARD'),
              const Gap(40),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Entrez votre courriel",
                  hintText: 'Courriel',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const Gap(16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  labelText: "Entrez votre mot de passe",
                  hintText: 'Mot de passe',
                ),
              ),
              const Gap(16),
              XGreenElevatedButton(
                onPressed: () {},
                label: "Se connecter",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
