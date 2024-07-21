import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    );
  }
}
