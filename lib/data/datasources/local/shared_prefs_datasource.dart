// lib/data/datasources/local/shared_prefs_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsDatasource {
  static const _keyRole = 'role_actif';
  static const _keyOnboarding = 'onboarding_fait';

  Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, role);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  Future<void> setOnboardingFait() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboarding, true);
  }

  Future<bool> isOnboardingFait() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboarding) ?? false;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
