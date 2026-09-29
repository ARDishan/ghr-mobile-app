class PhoneFormatter {
  PhoneFormatter._();

  static const String _countryCode = '+94';

  static String toE164(String rawInput) {
    final digitsOnly = rawInput.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.startsWith('94')) {
      return '+$digitsOnly';
    }
    if (digitsOnly.startsWith('0')) {
      return '$_countryCode${digitsOnly.substring(1)}';
    }
    return '$_countryCode$digitsOnly';
  }
}