class Validators {
  static bool isValidEmail(String email) {
    final trimmed = email.trim();
    final regex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    return regex.hasMatch(trimmed);
  }

  static bool isRequiredNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }
}

