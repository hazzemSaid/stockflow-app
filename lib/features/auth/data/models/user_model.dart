import 'package:makhzanflow/features/auth/domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.email, super.name});

  factory UserModel.fromSupabaseUser(supabase.User user) {
    final meta = user.userMetadata;
    final name =
        meta?['name'] as String? ??
        meta?['full_name'] as String? ??
        user.email?.split('@').first ??
        'UserName';
    return UserModel(id: user.id, email: user.email ?? '', name: name);
  }
}
