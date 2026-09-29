import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

/// Phone entered does not match an active customer in the `customers` table.
class AuthCustomerNotFound extends AuthState {}

/// OTP has been sent (or resent); UI should show the OTP entry step.
class AuthOtpSent extends AuthState {
  final String phone;
  const AuthOtpSent(this.phone);
  @override
  List<Object?> get props => [phone];
}

class AuthAuthenticated extends AuthState {
  final AuthUserEntity user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailureState extends AuthState {
  final String message;
  const AuthFailureState(this.message);
  @override
  List<Object?> get props => [message];
}