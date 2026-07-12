import 'package:makhzanflow/features/auth/domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.email, super.name});

  factory UserModel.fromSupabaseUser(supabase.User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] as String? ?? '',
    );
  }
}
