import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gap/gap.dart';
import 'package:xanoo_admin/core/common/entities/author.dart';
import 'package:xanoo_admin/core/widgets/loading_widget.dart';
import 'package:xanoo_admin/core/widgets/widget_helpers.dart';
import 'package:xanoo_admin/core/widgets/x_green_elevated_button.dart';
import 'package:xanoo_admin/features/library/presentation/blocs/authors/author_bloc.dart';
import 'package:xanoo_admin/features/library/presentation/pages/author_list_page.dart';

class AuthorUpdatePage extends StatefulWidget {
  const AuthorUpdatePage({super.key, required this.author});

  final Author author;

  @override
  State<AuthorUpdatePage> createState() => _AuthorUpdatePageState();
}

class _AuthorUpdatePageState extends State<AuthorUpdatePage> {
  late bool gender;

  final _formKey = GlobalKey<FormState>();

  bool getGenderBool() {
    if (widget.author.gender == 'M') {
      return true;
    }
    return false;
  }

  String getGenderChar(bool gender) {
    if (gender) {
      return 'M';
    }
    return 'F';
  }

  @override
  void initState() {
    gender = getGenderBool();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String firstName = widget.author.firstName;
    String lastName = widget.author.lastName;

    return BlocConsumer<AuthorBloc, AuthorState>(
      listener: (context, state) {
        if (state is AuthorFailure) {
          showSnakeBar(context, state.message);
        }

        if (state is AuthorSuccess) {
          context.read<AuthorBloc>().add(AuthorFetchAll());
          Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (_) => const AuthorListPage(),
            ),
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
                    initialValue: lastName,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      hintText: 'Entrez le nom',
                    ),
                    validator: RequiredValidator(
                      errorText: 'Le nom est requis',
                    ).call,
                    onChanged: (value) {
                      lastName = value;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const Gap(20),
                  TextFormField(
                    initialValue: firstName,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                      hintText: 'Entrez le prénom',
                    ),
                    validator: RequiredValidator(
                      errorText: 'Le prénom est requis',
                    ).call,
                    onChanged: (value) {
                      firstName = value;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const Gap(20),
                  XGreenElevatedButton(
                    onPressed: () {
                      final author = Author(
                        id: widget.author.id,
                        gender: getGenderChar(gender),
                        firstName: firstName,
                        lastName: lastName,
                      );

                      context.read<AuthorBloc>().add(
                            AuthorUpdate(
                              author: author,
                            ),
                          );
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
