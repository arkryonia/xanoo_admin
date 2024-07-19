import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xanoo_admin/core/error/server_exception.dart';
import 'package:xanoo_admin/features/library/data/models/author_model.dart';

abstract interface class AuthorSupabaseDS {
  Future<AuthorModel> create({
    required String gender,
    required String firstName,
    required String lastName,
  });

  Future<AuthorModel> read({required String id});

  Future<AuthorModel> update({
    required AuthorModel author,
  });

  Future<void> delete({required String id});

  Future<List<AuthorModel>> fetchAll();
}

class AuthorSupabaseDSImpl implements AuthorSupabaseDS {
  final SupabaseClient remoteClient;

  AuthorSupabaseDSImpl(this.remoteClient);

  @override
  Future<AuthorModel> create({
    required String gender,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await remoteClient.from('authors').insert({
        'gender': gender,
        'first_name': firstName,
        'last_name': lastName,
      }).select();

      return AuthorModel.fromMap(response.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await remoteClient.from('authors').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthorModel> read({required String id}) async {
    try {
      final response = await remoteClient
          .from('authors')
          .select('id, gender, first_name, last_name')
          .eq('id', id);

      return AuthorModel.fromMap(response.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthorModel> update({
    required AuthorModel author,
  }) async {
    try {
      final response = await remoteClient
          .from('authors')
          .update(author.toMap())
          .eq('id', author.id)
          .select();
      return AuthorModel.fromMap(response.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<AuthorModel>> fetchAll() async {
    try {
      final response = await remoteClient.from('authors').select();
      return response.map((e) => AuthorModel.fromMap(e)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
