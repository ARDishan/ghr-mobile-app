import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  final String userId;
  final String phone;
  final String? name;
  final String? email;
  final bool isGuest;

  const AuthUserEntity({
    required this.userId,
    required this.phone,
    this.name,
    this.email,
    this.isGuest = false,
  });

  @override
  List<Object?> get props => [userId, phone, name, email, isGuest];
}