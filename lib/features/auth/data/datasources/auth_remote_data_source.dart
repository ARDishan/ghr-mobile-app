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
      // shouldCreateUser is left at its default; since we've already gated
      // this behind checkCustomerExists, an auth.users row will be created
      // on first successful OTP verification for a known ERP customer.
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

      CustomerModel? customer;
      try {
        final row = await client
            .from('customers')
            .select()
            .eq('mobile', phone)
            .maybeSingle();
        if (row != null) {
          customer = CustomerModel.fromJson(row);
        }
      } catch (_) {
        // Non-fatal: the user is authenticated even if the profile lookup
        // fails. TODO: decide if this should actually be treated as fatal.
      }

      return AuthUserModel.fromSupabaseUser(user, customer: customer);
    } on supa.AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    final user = client.auth.currentUser;
    if (user == null) return null;

    CustomerModel? customer;
    try {
      final row = await client
          .from('customers')
          .select()
          .eq('mobile', user.phone ?? '')
          .maybeSingle();
      if (row != null) {
        customer = CustomerModel.fromJson(row);
      }
    } catch (_) {
      // Non-fatal, see note in verifyOtp above.
    }

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