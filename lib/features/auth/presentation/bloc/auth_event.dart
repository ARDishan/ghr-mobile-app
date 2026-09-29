import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// Checked on app start to restore an existing Supabase session.
class AuthCheckStatusRequested extends AuthEvent {
  const AuthCheckStatusRequested();
}

/// User submitted their phone number on the phone entry page.
class AuthPhoneSubmitted extends AuthEvent {
  final String phone; // already normalized to E.164 by the page/bloc
  const AuthPhoneSubmitted(this.phone);
  @override
  List<Object?> get props => [phone];
}

/// User tapped resend on the OTP page.
class AuthResendOtpRequested extends AuthEvent {
  final String phone;
  const AuthResendOtpRequested(this.phone);
  @override
  List<Object?> get props => [phone];
}

/// User submitted the OTP code.
class AuthOtpSubmitted extends AuthEvent {
  final String phone;
  final String otp;
  const AuthOtpSubmitted({required this.phone, required this.otp});
  @override
  List<Object?> get props => [phone, otp];
}

class AuthContinueAsGuestRequested extends AuthEvent {
  const AuthContinueAsGuestRequested();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}