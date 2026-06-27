// lib/core/utils/validators.dart
class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email requis';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email invalide';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Mot de passe requis';
    if (value.length < 6) return 'Min. 6 caractères';
    return null;
  }

  static String? nom(String? value) {
    if (value == null || value.isEmpty) return 'Nom requis';
    return null;
  }

  static String? telephone(String? value) {
    if (value == null || value.isEmpty) return 'Téléphone requis';
    if (value.replaceAll(' ', '').length < 8) {
      return 'Numéro invalide';
    }
    return null;
  }
}