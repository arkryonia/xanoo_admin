import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:xanoo_admin/core/common/entities/document.dart';
import 'package:xanoo_admin/core/widgets/loading_widget.dart';
import 'package:xanoo_admin/core/widgets/widget_helpers.dart';
import 'package:xanoo_admin/features/library/presentation/blocs/document/document_bloc.dart';
import 'package:xanoo_admin/features/library/presentation/pages/document_create_page.dart';

class DocumentListPage extends StatefulWidget {
  const DocumentListPage({super.key});

  static MaterialPageRoute goToDocumentCreatePage() {
    return MaterialPageRoute(
      builder: (_) => const DocumentCreatePage(),
    );
  }

  @override
  State<DocumentListPage> createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  List<Document> documents = [];

  @override
  void initState() {
    context.read<DocumentBloc>().add(DocumentFetchAll());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                DocumentListPage.goToDocumentCreatePage(),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
          const Gap(20),
        ],
      ),
      body: BlocConsumer<DocumentBloc, DocumentState>(
        listener: (context, state) {
          if (state is DocumentFailure) {
            showSnakeBar(context, state.message);
            log(state.message);
          }
          if (state is DocumentFetchAllSuccess) {
            documents = state.documents;
          }
          if (state is DocumentSuccess) {
            context.read<DocumentBloc>().add(DocumentFetchAll());
          }
        },
        builder: (context, state) {
          if (state is DocumentLoading) {
            return const LoadingWidget();
          }
          return documents.isEmpty
              ? const Center(
                  child: Text("Pas de documents disponibles"),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 60,
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    documents[index].title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    documents[index].authors.join(', '),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                // IconButton(
                                //   onPressed: () {
                                //     // Implémentez la logique de mise à jour ici
                                //   },
                                //   icon: const Icon(
                                //     Icons.edit_note,
                                //     color: Colors.green,
                                //   ),
                                // ),
                                const Gap(20),
                                IconButton(
                                  onPressed: () {
                                    context.read<DocumentBloc>().add(
                                          DocumentDelete(
                                            documents[index].id,
                                          ),
                                        );
                                    context
                                        .read<DocumentBloc>()
                                        .add(DocumentFetchAll());
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
