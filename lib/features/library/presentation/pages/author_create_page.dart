import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gap/gap.dart';
import 'package:xanoo_admin/core/widgets/loading_widget.dart';
import 'package:xanoo_admin/core/widgets/widget_helpers.dart';
import 'package:xanoo_admin/core/widgets/x_green_elevated_button.dart';
import 'package:xanoo_admin/features/library/presentation/blocs/authors/author_bloc.dart';
import 'package:xanoo_admin/features/library/presentation/pages/author_list_page.dart';

class AuthorCreatePage extends StatefulWidget {
  const AuthorCreatePage({super.key});

  static MaterialPageRoute goToListAuthorsPage() {
    return MaterialPageRoute(
      builder: (_) => const AuthorListPage(),
    );
  }

  @override
  State<AuthorCreatePage> createState() => _AuthorCreatePageState();
}

class _AuthorCreatePageState extends State<AuthorCreatePage> {
  bool gender = false;

  final _formKey = GlobalKey<FormState>();

  String _gender = '';
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthorBloc, AuthorState>(
      listener: (context, state) {
        if (state is AuthorFailure) {
          showSnakeBar(context, state.message);
        }

        if (state is AuthorSuccess) {
          context.read<AuthorBloc>().add(AuthorFetchAll());
          Navigator.pop(
            context,
            AuthorCreatePage.goToListAuthorsPage(),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthorLoading) {
          return const LoadingWidget();
        }
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 350,
              vertical: 50,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FlutterSwitch(
                          width: double.infinity,
                          height: 50,
                          borderRadius: 50,
                          activeColor: Colors.blue,
                          activeIcon: const Icon(Icons.male),
                          inactiveColor: Colors.pink,
                          inactiveIcon: const Icon(Icons.female),
                          toggleSize: 45,
                          value: gender,
                          onToggle: (value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      hintText: 'Entrez le nom',
                    ),
                    validator: RequiredValidator(
                      errorText: 'Le nom est requis',
                    ).call,
                    controller: _lastName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const Gap(20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                      hintText: 'Entrez le prénom',
                    ),
                    validator: RequiredValidator(
                      errorText: 'Le prénom est requis',
                    ).call,
                    controller: _firstName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const Gap(20),
                  XGreenElevatedButton(
                    onPressed: () {
                      gender ? _gender = 'M' : _gender = 'F';
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthorBloc>().add(
                              AuthorCreate(
                                _gender,
                                _firstName.text.trim(),
                                _lastName.text.trim(),
                              ),
                            );
                      }
                    },
                    label: 'Soumettre',
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
