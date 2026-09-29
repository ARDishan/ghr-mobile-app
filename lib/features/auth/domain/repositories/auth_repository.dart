import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user_entity.dart';

abstract class AuthRepository {
  /// Checks the `customers` table (via the check_customer_exists RPC) to
  /// see if [phone] (E.164) belongs to an active GHR customer.
  Future<Either<Failure, bool>> checkCustomerExists(String phone);

  /// Sends an OTP to [phone] via Supabase Auth (Dialog SMS under the hood).
  Future<Either<Failure, void>> sendOtp(String phone);

  /// Resends an OTP to [phone].
  Future<Either<Failure, void>> resendOtp(String phone);

  /// Verifies [otp] for [phone] and returns the authenticated user.
  Future<Either<Failure, AuthUserEntity>> verifyOtp({
    required String phone,
    required String otp,
  });

  /// Returns the currently authenticated user, if any (session restoration).
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser();

  /// Signs in as a guest (no Supabase session, local-only state).
  Future<Either<Failure, AuthUserEntity>> continueAsGuest();

  /// Signs out.
  Future<Either<Failure, void>> logout();
}