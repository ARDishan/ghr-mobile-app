import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _fmt = NumberFormat('#,##0.00', 'en_US');

  static String lkr(num? value) =>
      value == null ? '-' : 'LKR ${_fmt.format(value)}';
}