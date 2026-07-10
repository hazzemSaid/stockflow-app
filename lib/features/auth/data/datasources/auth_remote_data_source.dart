import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp(String email, String password, String name);
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final supabase.SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      if (response.user == null) {
        throw const AuthException(AppStrings.userDataNotFound);
      }
      final user = response.user!;
      return UserModel.fromSupabaseUser(user);
    } on supabase.AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw const ServerException(AppStrings.unexpectedError);
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((event) {
      if (event.session?.user != null) {
        return UserModel.fromSupabaseUser(event.session!.user);
      }
      return null;
    });
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user != null) {
        return UserModel.fromSupabaseUser(user);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const AuthException(AppStrings.userDataNotFound);
      }
      return UserModel.fromSupabaseUser(response.user!);
    } on supabase.AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw const ServerException(AppStrings.unexpectedError);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
