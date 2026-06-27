// lib/core/utils/formatter.dart
class Formatter {
  static String telephone(String phone) {
    // Format: 70 12 34 56
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 8) {
      return '${cleaned.substring(0, 2)} ${cleaned.substring(2, 4)} ${cleaned.substring(4, 6)} ${cleaned.substring(6, 8)}';
    }
    return phone;
  }

  static String date(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return "Aujourd'hui";
    if (diff.inDays == 1) return "Hier";
    if (diff.inDays < 7) return "Il y a ${diff.inDays} jours";
    return "${date.day}/${date.month}/${date.year}";
  }
}