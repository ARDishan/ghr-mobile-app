import 'package:supabase_flutter/supabase_flutter.dart' show User;
import '../../domain/entities/auth_user_entity.dart';
import 'customer_model.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.userId,
    required super.phone,
    super.name,
    super.email,
    super.isGuest,
  });

  /// Builds the model from a Supabase [User] plus the matching row from the
  /// `customers` table (may be null if the lookup hasn't been performed/found
  /// a match yet — TODO: decide how to surface that edge case to the UI).
  factory AuthUserModel.fromSupabaseUser(User user, {CustomerModel? customer}) {
    return AuthUserModel(
      userId: user.id,
      phone: user.phone ?? '',
      name: customer?.name,
      email: customer?.email ?? user.email,
      isGuest: false,
    );
  }

  factory AuthUserModel.guest(String localId) {
    return AuthUserModel(
      userId: localId,
      phone: '',
      name: 'Guest',
      isGuest: true,
    );
  }
}