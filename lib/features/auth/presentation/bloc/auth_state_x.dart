import 'auth_state.dart';

extension AuthStateX on AuthState {
  /// Logged in with a real (OTP-verified) customer session.
  bool get isCustomer {
    final s = this;
    return s is AuthAuthenticated && !s.user.isGuest;
  }

  bool get isGuest {
    final s = this;
    return s is AuthAuthenticated && s.user.isGuest;
  }
}