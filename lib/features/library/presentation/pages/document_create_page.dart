import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:xanoo_admin/core/common/entities/author.dart';
import 'package:xanoo_admin/core/widgets/loading_widget.dart';
import 'package:xanoo_admin/core/widgets/widget_helpers.dart';
import 'package:xanoo_admin/core/widgets/x_green_elevated_button.dart';
import 'package:xanoo_admin/features/library/presentation/blocs/authors/author_bloc.dart';
import 'package:xanoo_admin/features/library/presentation/blocs/document/document_bloc.dart';
import 'package:xanoo_admin/features/library/presentation/pages/document_list_page.dart';

class DocumentCreatePage extends StatefulWidget {
  const DocumentCreatePage({super.key});

  static MaterialPageRoute goToDocumentListPage() {
    return MaterialPageRoute(
      builder: (context) => const DocumentListPage(),
    );
  }

  @override
  State<DocumentCreatePage> createState() => _DocumentCreatePageState();
}

class _DocumentCreatePageState extends State<DocumentCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _tag = TextEditingController();
  final _author = TextEditingController();

  String? _selectedNature;
  String? _selectedLanguage;

  File? _file;
  File? _cover;
  final List<String> _tags = [];
  final List<Author> _selectedAuthors = [];

  // Liste des natures de document
  final List<String> _natureList = [
    'Livre',
    'Article',
    'Thèse',
    'Rapport',
    'Manuel'
  ];

  // Liste des langues de document
  final List<String> _languageList = [
    'Fongbe',
    'Yoruba',
    'Baatonum',
    'Fulfulɖe',
    'Dendi',
    'Boo',
  ];

  @override
  void initState() {
    super.initState();
    context.read<AuthorBloc>().add(AuthorFetchAll());
  }

  static String _displayStringForOption(Author option) =>
      '${option.lastName} ${option.firstName}';

  Future<void> _pickFile(bool isCover) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: isCover ? FileType.image : FileType.custom,
      allowedExtensions: isCover ? ['png', 'jpg', 'jpeg'] : ['epub', 'pdf'],
    );

    if (result != null) {
      setState(() {
        if (isCover) {
          _cover = File(result.files.single.path!);
        } else {
          _file = File(result.files.single.path!);
        }
      });
    }
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tag.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double formWidth = MediaQuery.of(context).size.width * 0.5;
    return BlocConsumer<DocumentBloc, DocumentState>(
      listener: (context, state) {
        if (state is DocumentFailure) {
          showSnakeBar(context, state.message);
        }
        if (state is DocumentSuccess) {
          showSnakeBar(context, 'Document created', Colors.green);
          context.read<DocumentBloc>().add(DocumentFetchAll());
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is DocumentLoading) {
          return const LoadingWidget();
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Créer un document')),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: formWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _title,
                          decoration: const InputDecoration(labelText: 'Titre'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un titre';
                            }
                            return null;
                          },
                        ),
                        const Gap(15),
                        TextFormField(
                          controller: _description,
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                        ),
                        const Gap(15),
                        DropdownButtonFormField<String>(
                          value: _selectedNature,
                          decoration: const InputDecoration(
                            labelText: 'Nature',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                          ),
                          items: _natureList.map((String nature) {
                            return DropdownMenuItem(
                              value: nature,
                              child: Text(nature),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedNature = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez sélectionner la nature du document';
                            }
                            return null;
                          },
                        ),
                        const Gap(15),
                        // Langues
                        DropdownButtonFormField<String>(
                          value: _selectedLanguage,
                          decoration: const InputDecoration(
                            labelText: 'Langue',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                          ),
                          items: _languageList.map((String language) {
                            return DropdownMenuItem(
                              value: language,
                              child: Text(language),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedLanguage = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez sélectionner la langue du document';
                            }
                            return null;
                          },
                        ),
                        const Gap(15),
                        ElevatedButton(
                          onPressed: () => _pickFile(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _file != null ? Colors.amber : null,
                          ),
                          child: Text(_file == null
                              ? 'Sélectionner un fichier'
                              : 'Fichier ajouté'),
                        ),
                        const Gap(15),
                        ElevatedButton(
                          onPressed: () => _pickFile(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _cover != null ? Colors.amber : null,
                          ),
                          child: Text(_cover == null
                              ? 'Sélectionner une couverture'
                              : 'Couverture ajoutée'),
                        ),
                        const Gap(15),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _tag,
                                decoration: InputDecoration(
                                  labelText: 'Ajouter un tag',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.add_circle),
                                    onPressed: () => _addTag(_tag.text),
                                  ),
                                ),
                                onFieldSubmitted: _addTag,
                              ),
                            ),
                          ],
                        ),
                        const Gap(15),
                        Wrap(
                          spacing: 8.0,
                          children: _tags
                              .map((tag) => Chip(
                                    label: Text(tag),
                                    onDeleted: () {
                                      setState(() {
                                        _tags.remove(tag);
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                        const Gap(15),
                        BlocBuilder<AuthorBloc, AuthorState>(
                          builder: (context, state) {
                            if (state is AuthorFecthAllSuccess) {
                              return Autocomplete<Author>(
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<Author>.empty();
                                  }
                                  return state.authors.where((Author option) {
                                    return option
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Author selection) {
                                  setState(() {
                                    if (!_selectedAuthors.contains(selection)) {
                                      _selectedAuthors.add(selection);
                                    }
                                  });
                                  _author.clear();
                                },
                                fieldViewBuilder: (
                                  context,
                                  fieldTextEditingController,
                                  fieldFocusNode,
                                  onFieldSubmitted,
                                ) {
                                  return TextFormField(
                                    controller: fieldTextEditingController,
                                    focusNode: fieldFocusNode,
                                    decoration: const InputDecoration(
                                      labelText: 'Rechercher un auteur',
                                    ),
                                  );
                                },
                                optionsViewBuilder:
                                    (context, onSelected, options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 4.0,
                                      child: SizedBox(
                                        width: formWidth,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: options.length,
                                          itemBuilder: (context, index) {
                                            final Author option =
                                                options.elementAt(index);
                                            return InkWell(
                                              onTap: () => onSelected(option),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                    _displayStringForOption(
                                                        option)),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (state is AuthorLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return const Text(
                                  'Erreur lors du chargement des auteurs');
                            }
                          },
                        ),
                        const Gap(15),
                        Wrap(
                          spacing: 8.0,
                          children: _selectedAuthors
                              .map((author) => Chip(
                                    label:
                                        Text(_displayStringForOption(author)),
                                    onDeleted: () {
                                      setState(() {
                                        _selectedAuthors.remove(author);
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                        const Gap(15),
                        XGreenElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_cover == null || _file == null) {
                                showSnakeBar(context, 'Ajouter les assets');
                              } else {
                                context.read<DocumentBloc>().add(
                                      DocumentCreate(
                                        title: _title.text.trim(),
                                        description: _description.text.trim(),
                                        nature: _selectedNature!,
                                        language: _selectedLanguage!,
                                        file: _file!,
                                        cover: _cover!,
                                        authors: _selectedAuthors
                                            .map((value) => value.id)
                                            .toList(),
                                        tags: _tags,
                                      ),
                                    );
                              }
                            }
                          },
                          label: 'Sauvegarder le document',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _tag.dispose();
    _author.dispose();
    super.dispose();
  }
}
