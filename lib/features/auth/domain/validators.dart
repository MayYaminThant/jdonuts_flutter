abstract final class Validators {
  static const minimumAge = 13;

  static String normalizePhone(String value) {
    var digits = value.replaceAll(RegExp(r'[\s-]'), '');
    if (digits.startsWith('+95')) digits = digits.substring(3);
    if (digits.startsWith('0')) digits = digits.substring(1);
    return digits;
  }

  static bool phone(String value) =>
      RegExp(r'^9\d{7,9}$').hasMatch(normalizePhone(value));

  static bool otp(String value) => RegExp(r'^\d{6}$').hasMatch(value);

  static bool name(String value, {bool optional = false}) {
    final v = value.trim();
    if (optional && v.isEmpty) return true;
    return v.isNotEmpty &&
        v.length <= 50 &&
        RegExp(r'^[a-zA-Z\u1000-\u109F\uAA60-\uAA7F\s]+$').hasMatch(v);
  }

  static bool birthDate(int year, int month, int day, {DateTime? now}) {
    final today = now ?? DateTime.now();
    if (year < 1900 || month < 1 || month > 12 || day < 1 || day > 31) {
      return false;
    }
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return false;
    }
    final latest = DateTime(today.year - minimumAge, today.month, today.day);
    return !date.isAfter(latest);
  }
}
