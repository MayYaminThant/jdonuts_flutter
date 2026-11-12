import 'package:intl/intl.dart';

class NumberFormatUtil {
  static String formatPrice(double price) {
    return NumberFormat('#,##0.00').format(price);
  }

  static String formatQty(dynamic qty) {
    return NumberFormat('#,##0').format(qty);
  }

  static String formatInt(int number) {
    return NumberFormat('#,##0').format(number);
  }
}
