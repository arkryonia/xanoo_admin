import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:xanoo_admin/core/widgets/loading_widget.dart';
import 'package:xanoo_admin/core/widgets/widget_helpers.dart';
import 'package:xanoo_admin/features/library/presentation/blocs/document/document_bloc.dart';
import 'package:xanoo_admin/features/library/presentation/pages/document_create_page.dart';

class ListDocumentsPage extends StatefulWidget {
  const ListDocumentsPage({super.key});

  static MaterialPageRoute goToAddDocumentPage() {
    return MaterialPageRoute(
      builder: (_) => const DocumentCreatePage(),
    );
  }

  @override
  State<ListDocumentsPage> createState() => _ListDocumentsPageState();
}

class _ListDocumentsPageState extends State<ListDocumentsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentBloc, DocumentState>(
      listener: (context, state) {
        if (state is DocumentFailure) {
          showSnakeBar(context, state.message);
        }
        if (state is DocumentSuccess) {
          showSnakeBar(context, 'Success', Colors.green);
        }
      },
      builder: (context, state) {
        if (state is DocumentLoading) {
          return const LoadingWidget();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "xDocuments",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    ListDocumentsPage.goToAddDocumentPage(),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
              ),
              const Gap(20),
            ],
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<DocumentBloc>().add(DocumentFetchAll());
              },
              child: const Text(
                'Lister les document',
              ),
            ),
          ),
        );
      },
    );
  }
}
