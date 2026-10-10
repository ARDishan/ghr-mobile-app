import '../constants/app_constants.dart';
import 'phone_formatter.dart';

class Validators {
  Validators._();

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Mobile number is required';
    if (!PhoneFormatter.isValid(PhoneFormatter.toE164(value))) {
      return 'Enter a valid mobile number';
    }
    return null;
  }

  static String? otp(String? value, {int length = AppConstants.otpLength}) {
    if (value == null || value.trim().isEmpty) return 'Enter the code';
    if (!RegExp('^[0-9]{$length}\$').hasMatch(value.trim())) {
      return 'Enter the $length-digit code';
    }
    return null;
  }
}