import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:xanoo_admin/core/common/entities/author.dart';
import 'package:xanoo_admin/core/widgets/loading_widget.dart';
import 'package:xanoo_admin/core/widgets/widget_helpers.dart';
import 'package:xanoo_admin/features/library/presentation/blocs/authors/author_bloc.dart';

class AuthorListPage extends StatefulWidget {
  const AuthorListPage({super.key});

  @override
  State<AuthorListPage> createState() => _AuthorListPageState();
}

class _AuthorListPageState extends State<AuthorListPage> {
  List<Author> authors = [];

  @override
  void initState() {
    context.read<AuthorBloc>().add(AuthorFetchAll());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "xAuteurs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline),
          ),
          const Gap(20),
        ],
      ),
      body: BlocConsumer<AuthorBloc, AuthorState>(
        listener: (context, state) {
          if (state is AuthorFailure) {
            showSnakeBar(context, state.message);
          }

          if (state is AuthorFecthAllSuccess) {
            authors = state.authors;
          }
        },
        builder: (context, state) {
          if (state is AuthorLoading) {
            return const LoadingWidget();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: authors.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 60,
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            authors[index].gender == 'M'
                                ? const Text('M.')
                                : const Text('Mme'),
                            const Gap(10),
                            Text('${authors[index].firstName} '),
                            Text(
                              authors[index].lastName.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit_note,
                              color: Colors.green,
                            ),
                          ),
                          const Gap(20),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<AuthorBloc>()
                                  .add(AuthorDelete(authors[index].id));
                              context.read<AuthorBloc>().add(AuthorFetchAll());
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(height: 0);
            },
          );
        },
      ),
    );
  }
}
