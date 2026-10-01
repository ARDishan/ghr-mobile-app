class PhoneFormatter {
  PhoneFormatter._();

  static const String _countryCode = '+94';

  /// Converts whatever the user typed into E.164 for Supabase Auth.
  /// Accepts:  +94712345678 | 94712345678 | 0712345678 | 712345678
  /// and any of them with spaces, dashes or brackets ("94 712 345 678"),
  /// "0094712345678", and "+94 (0) 71 234 5678".
  /// A number typed with an explicit non-Sri-Lankan "+"/"00" prefix is kept as is.
  static String toE164(String rawInput) {
    final trimmed = rawInput.trim();
    var digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '';

    final explicitInternational = trimmed.startsWith('+') || digits.startsWith('00');
    if (digits.startsWith('00')) digits = digits.substring(2);

    // "+94 (0) 71..." / "940712345678": drop the stray national 0.
    if (digits.startsWith('940') && digits.length == 12) {
      digits = '94${digits.substring(3)}';
    }

    if (explicitInternational) return '+$digits';
    if (digits.startsWith('94')) return '+$digits';
    if (digits.startsWith('0')) return '$_countryCode${digits.substring(1)}';
    return '$_countryCode$digits';
  }

  /// Basic sanity check on an E.164 value (Sri Lankan mobiles are +94 + 9 digits).
  static bool isValid(String e164) {
    if (e164.startsWith('+94')) return RegExp(r'^\+94[0-9]{9}$').hasMatch(e164);
    return RegExp(r'^\+[0-9]{8,15}$').hasMatch(e164);
  }
}