import 'dart:developer';
import 'dart:io';

import 'package:supabase/supabase.dart';
import 'package:xanoo_admin/core/error/server_exception.dart';
import 'package:xanoo_admin/features/library/data/models/document_model.dart';

abstract interface class DocumentSupabaseDS {
  Future<DocumentModel> create({required DocumentModel document});
  Future<String> uploadAsset({
    required File asset,
    required DocumentModel document,
    bool isCover = false,
  });

  Future<List<DocumentModel>> fetchAll();

  Future<void> delete({required String id});
}

class DocumentSupabaseDSImpl implements DocumentSupabaseDS {
  final SupabaseClient remoteClient;

  DocumentSupabaseDSImpl(this.remoteClient);

  @override
  Future<DocumentModel> create({required DocumentModel document}) async {
    try {
      final response = await remoteClient.rpc('insert_document', params: {
        'p_title': document.title,
        'p_description': document.description,
        'p_nature': document.nature,
        'p_language': document.language,
        'p_file_url': document.filePath,
        'p_cover_url': document.coverPath,
        'p_tags': document.tags,
        'p_author_ids': document.authors,
      });

      log('Réponse brute reçue : $response');
      log('Type de la réponse : ${response.runtimeType}');

      if (response == null) {
        throw ServerException('No data returned from insert_document function');
      }

      if (response is List && response.isNotEmpty) {
        final documentData = response.first;
        if (documentData is Map<String, dynamic>) {
          log('Création du DocumentModel avec les données : $documentData');
          return DocumentModel.fromMap(documentData);
        }
      }

      log('Réponse non conforme : $response');
      throw ServerException(
        'Unexpected response format from insert_document function',
      );
    } on PostgrestException catch (e) {
      log('PostgrestException attrapée : ${e.message}');
      throw ServerException(e.message);
    } catch (e) {
      log('Exception inattendue attrapée : $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadAsset({
    required File asset,
    required DocumentModel document,
    bool isCover = false,
  }) async {
    // Construire le chemin avec l'extension du fichier
    String fileName = asset.path.split('/').last;
    String extension = fileName.split('.').last;
    String path = isCover
        ? 'covers/${document.id}.$extension'
        : 'docs/${document.id}.$extension';

    try {
      // Upload du fichier
      await remoteClient.storage.from('assets').upload(
            path,
            asset,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // Récupération de l'URL publique
      final String publicUrl =
          remoteClient.storage.from('assets').getPublicUrl(path);

      log('Generated public URL: $publicUrl');
      return publicUrl;
    } on PostgrestException catch (e) {
      log('PostgrestException during upload: ${e.message}');
      throw ServerException(e.message);
    } on StorageException catch (e) {
      log('StorageException during upload: ${e.message}');
      throw ServerException(e.message);
    } catch (e) {
      log('Unexpected error during upload: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<DocumentModel>> fetchAll() async {
    try {
      final response = await remoteClient.from('documents').select('''
          id,
          title,
          description,
          nature,
          language,
          file_url,
          cover_url,
          tags,
          authors (
            id,
            first_name,
            last_name
          )
        ''');

      final List<dynamic> data = response as List<dynamic>;
      return data.map((documentData) {
        final List<dynamic> authorsData =
            documentData['authors'] as List<dynamic>;
        final List<String> authors = authorsData.map((author) {
          return '${author['first_name']} ${author['last_name']}';
        }).toList();

        return DocumentModel(
          id: documentData['id'],
          title: documentData['title'],
          description: documentData['description'],
          nature: documentData['nature'],
          language: documentData['language'],
          filePath: documentData['file_url'],
          coverPath: documentData['cover_url'],
          tags: List<String>.from(documentData['tags']),
          authors: authors,
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await remoteClient.from('documents').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
