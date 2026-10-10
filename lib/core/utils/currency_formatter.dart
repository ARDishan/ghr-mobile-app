import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _fmt = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat _whole = NumberFormat('#,##0', 'en_US');

  /// LKR 1,234,567.00
  static String lkr(num? value) =>
      value == null ? '-' : 'LKR ${_fmt.format(value)}';

  /// LKR 1,234,567 (for prices where cents are noise)
  static String lkrWhole(num? value) =>
      value == null ? '-' : 'LKR ${_whole.format(value)}';
}
