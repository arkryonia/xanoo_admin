import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:xanoo_admin/core/common/entities/author.dart';
import 'package:xanoo_admin/core/widgets/x_green_elevated_button.dart';
import 'package:xanoo_admin/features/library/presentation/blocs/authors/author_bloc.dart';

class DocumentCreatePage extends StatefulWidget {
  const DocumentCreatePage({super.key});

  @override
  State<DocumentCreatePage> createState() => _DocumentCreatePageState();
}

class _DocumentCreatePageState extends State<DocumentCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();
  final _authorController = TextEditingController();

  String? _selectedNature;
  PlatformFile? _file;
  PlatformFile? _cover;
  final List<String> _tags = [];
  final List<Author> _selectedAuthors = [];

  // Liste des natures de document
  final List<String> _natureList = [
    '',
    'Livre',
    'Article',
    'Thèse',
    'Rapport',
    'Manuel'
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
        isCover ? _cover = result.files.first : _file = result.files.first;
      });
    }
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double formWidth = MediaQuery.of(context).size.width * 0.5;
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
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Titre'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un titre';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    const Gap(20),
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
                    const Gap(20),
                    ElevatedButton(
                      onPressed: () => _pickFile(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _file != null ? Colors.amber : null,
                      ),
                      child: Text(_file == null
                          ? 'Sélectionner un fichier'
                          : 'Fichier sélectionné: ${_file!.name}'),
                    ),
                    const Gap(20),
                    ElevatedButton(
                      onPressed: () => _pickFile(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _cover != null ? Colors.amber : null,
                      ),
                      child: Text(_cover == null
                          ? 'Sélectionner une couverture'
                          : 'Couverture sélectionnée: ${_cover!.name}'),
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _tagController,
                            decoration: InputDecoration(
                              labelText: 'Ajouter un tag',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.add_circle),
                                onPressed: () => _addTag(_tagController.text),
                              ),
                            ),
                            onFieldSubmitted: _addTag,
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
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
                    const Gap(20),
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
                                return option.toString().toLowerCase().contains(
                                    textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (Author selection) {
                              setState(() {
                                if (!_selectedAuthors.contains(selection)) {
                                  _selectedAuthors.add(selection);
                                }
                              });
                              _authorController.clear();
                            },
                            fieldViewBuilder: (context,
                                fieldTextEditingController,
                                fieldFocusNode,
                                onFieldSubmitted) {
                              return TextFormField(
                                controller: fieldTextEditingController,
                                focusNode: fieldFocusNode,
                                decoration: const InputDecoration(
                                  labelText: 'Rechercher un auteur',
                                ),
                              );
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(_displayStringForOption(
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
                          return const CircularProgressIndicator();
                        } else {
                          return const Text(
                              'Erreur lors du chargement des auteurs');
                        }
                      },
                    ),
                    const Gap(20),
                    Wrap(
                      spacing: 8.0,
                      children: _selectedAuthors
                          .map((author) => Chip(
                                label: Text(_displayStringForOption(author)),
                                onDeleted: () {
                                  setState(() {
                                    _selectedAuthors.remove(author);
                                  });
                                },
                              ))
                          .toList(),
                    ),
                    const Gap(20),
                    XGreenElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Implement logic to save the document
                          print('Document valid, ready to be saved');
                          // Here, you should call a function to send the data,
                          // including _file and _cover, to your backend
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
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    _authorController.dispose();
    super.dispose();
  }
}
