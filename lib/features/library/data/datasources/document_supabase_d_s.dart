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
        'p_file_url': document.filePath,
        'p_cover_url': document.coverPath,
        'p_tags': document.tags,
        'p_author_ids': document.authors,
      });

      print('Réponse brute reçue : $response');
      print('Type de la réponse : ${response.runtimeType}');

      if (response == null) {
        throw ServerException('No data returned from insert_document function');
      }

      if (response is List && response.isNotEmpty) {
        final documentData = response.first;
        if (documentData is Map<String, dynamic>) {
          print('Création du DocumentModel avec les données : $documentData');
          return DocumentModel.fromMap(documentData);
        }
      }

      print('Réponse non conforme : $response');
      throw ServerException(
        'Unexpected response format from insert_document function',
      );
    } on PostgrestException catch (e) {
      print('PostgrestException attrapée : ${e.message}');
      throw ServerException(e.message);
    } catch (e) {
      print('Exception inattendue attrapée : $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadAsset({
    required File asset,
    required DocumentModel document,
    bool isCover = false,
  }) async {
    String path = isCover ? 'covers/${document.id}' : 'docs/${document.id}';
    try {
      await remoteClient.storage.from('assets').upload(path, asset);
      return remoteClient.storage.from('assets').getPublicUrl(document.id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<DocumentModel>> fetchAll() async {
    try {
      final response = await remoteClient
          .from('documents')
          .select('title, nature, authors(id, first_name, last_name)');

      print(response);
      return [];
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
