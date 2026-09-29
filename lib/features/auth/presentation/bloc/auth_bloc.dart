import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_customer_exists.dart';
import '../../domain/usecases/continue_as_guest.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/resend_otp.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/verify_otp.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckCustomerExists checkCustomerExists;
  final SendOtp sendOtp;
  final ResendOtp resendOtp;
  final VerifyOtp verifyOtp;
  final GetCurrentUser getCurrentUser;
  final ContinueAsGuest continueAsGuest;
  final Logout logout;

  AuthBloc({
    required this.checkCustomerExists,
    required this.sendOtp,
    required this.resendOtp,
    required this.verifyOtp,
    required this.getCurrentUser,
    required this.continueAsGuest,
    required this.logout,
  }) : super(AuthInitial()) {
    on<AuthCheckStatusRequested>(_onCheckStatus);
    on<AuthPhoneSubmitted>(_onPhoneSubmitted);
    on<AuthResendOtpRequested>(_onResendOtp);
    on<AuthOtpSubmitted>(_onOtpSubmitted);
    on<AuthContinueAsGuestRequested>(_onContinueAsGuest);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getCurrentUser();
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) => emit(user != null ? AuthAuthenticated(user) : AuthUnauthenticated()),
    );
  }

  Future<void> _onPhoneSubmitted(
    AuthPhoneSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final existsResult = await checkCustomerExists(event.phone);
    final exists = existsResult.fold((failure) => null, (value) => value);

    if (exists == null) {
      emit(existsResult.fold((f) => AuthFailureState(f.message), (_) => AuthFailureState('Unknown error')));
      return;
    }
    if (!exists) {
      emit(AuthCustomerNotFound());
      return;
    }

    final otpResult = await sendOtp(event.phone);
    otpResult.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (_) => emit(AuthOtpSent(event.phone)),
    );
  }

  Future<void> _onResendOtp(
    AuthResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await resendOtp(event.phone);
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (_) => emit(AuthOtpSent(event.phone)),
    );
  }

  Future<void> _onOtpSubmitted(
    AuthOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifyOtp(
      VerifyOtpParams(phone: event.phone, otp: event.otp),
    );
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onContinueAsGuest(
    AuthContinueAsGuestRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await continueAsGuest();
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logout();
    emit(AuthUnauthenticated());
  }
}