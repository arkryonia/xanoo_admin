import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xanoo_admin/core/error/server_exception.dart';
import 'package:xanoo_admin/features/auth/data/models/user_model.dart';

abstract interface class AuthSupabase {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserModel> updateRole({required String id, required String role});
  Future<void> signOut();
}

class AuthSupabaseImpl implements AuthSupabase {
  final SupabaseClient remoteClient;

  AuthSupabaseImpl(this.remoteClient);

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final newUser = response.user!;

      return UserModel.fromMap(newUser.toJson()).copyWith(
        id: newUser.id,
        email: newUser.email,
        role: newUser.role,
      );
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateRole(
      {required String id, required String role}) async {
    try {
      final response = await remoteClient
          .from('auth.users')
          .update({'role': role})
          .eq('id', id)
          .select();
      return UserModel.fromMap(response.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteClient.auth.signOut();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
