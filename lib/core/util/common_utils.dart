import 'dart:convert';

class CommonUtil {
  static String safeString(dynamic v) => v is String ? v : '';

  static int safeInt(dynamic v) =>
      v == null ? 0 : (double.tryParse(v.toString())?.toInt() ?? 0);

  static double safeDouble(dynamic v) =>
      double.tryParse(v?.toString() ?? '') ?? 0.0;

  static bool safeBool(dynamic v) => v == true || v == "true" || v == 1;

  static List<dynamic> safeJsonList(dynamic value) {
    if (value == null) return [];

    if (value is List) return value;

    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        return decoded is List ? decoded : [];
      } catch (_) {
        return [];
      }
    }

    return [];
  }
}
