import 'dart:io';

import 'package:supabase/supabase.dart';
import 'package:xanoo_admin/core/error/server_exception.dart';
import 'package:xanoo_admin/features/library/data/models/document_model.dart';

abstract interface class DocumentSupabaseDS {
  Future<void> create({required DocumentModel document});
  Future<String> uploadAsset({
    required File asset,
    required DocumentModel document,
    bool isCover = false,
  });
}

class DocumentSupabaseDSImpl implements DocumentSupabaseDS {
  final SupabaseClient remoteClient;

  DocumentSupabaseDSImpl(this.remoteClient);

  @override
  Future<void> create({required DocumentModel document}) async {
    try {
      await remoteClient.rpc('insert_document', params: {
        'p_title': document.title,
        'p_description': document.description,
        'p_nature': document.nature,
        'p_file_url': document.filePath,
        'p_cover_url': document.coverPath,
        'p_tags': document.tags,
        'p_author_ids': document.authors,
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
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
    print('$asset ---- from datasource --- ${document.id}');
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
}
