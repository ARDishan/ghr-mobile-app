import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../../../core/errors/exceptions.dart';
import '../models/auth_user_model.dart';
import '../models/customer_model.dart';

abstract class AuthRemoteDataSource {
  Future<bool> checkCustomerExists(String phone);
  Future<void> sendOtp(String phone);
  Future<void> resendOtp(String phone);
  Future<AuthUserModel> verifyOtp({required String phone, required String otp});
  Future<AuthUserModel?> getCurrentUser();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final supa.SupabaseClient client;
  AuthRemoteDataSourceImpl(this.client);

  /// Fetches the logged-in customer's row. `customers.mobile` can be stored in
  /// any format ("+94...", "94...", "07...", with spaces), so we do NOT filter
  /// by mobile here: Row Level Security (which compares normalised numbers)
  /// already returns only the caller's own row. Failures are logged.
  Future<CustomerModel?> _fetchCustomer() async {
    try {
      final row = await client.from('customers').select().limit(1).maybeSingle();
      return row == null ? null : CustomerModel.fromJson(row);
    } catch (e) {
      debugPrint('Customer lookup failed: $e');
      return null;
    }
  }

  @override
  Future<bool> checkCustomerExists(String phone) async {
    try {
      final result = await client.rpc(
        'check_customer_exists',
        params: {'p_mobile': phone},
      );
      return result as bool;
    } on supa.PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendOtp(String phone) async {
    try {
      await client.auth.signInWithOtp(phone: phone);
    } on supa.AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resendOtp(String phone) => sendOtp(phone);

  @override
  Future<AuthUserModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await client.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: supa.OtpType.sms,
      );
      final user = response.user;
      if (user == null) {
        throw AuthException('OTP verification did not return a user.');
      }
      final customer = await _fetchCustomer();
      return AuthUserModel.fromSupabaseUser(user, customer: customer);
    } on supa.AuthException catch (e) {
      throw AuthException(e.message);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    final user = client.auth.currentUser;
    if (user == null) return null;
    final customer = await _fetchCustomer();
    return AuthUserModel.fromSupabaseUser(user, customer: customer);
  }

  @override
  Future<void> logout() async {
    try {
      await client.auth.signOut();
    } on supa.AuthException catch (e) {
      throw AuthException(e.message);
    }
  }
}