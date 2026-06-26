import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/constants.dart';

class SharedPrefsDatasource {
  final SharedPreferences prefs;

  SharedPrefsDatasource(this.prefs);

  bool getRoleActif() => prefs.getBool(AppConstants.prefRoleActifKey) ?? false;

  Future<void> setRoleActif(bool value) =>
      prefs.setBool(AppConstants.prefRoleActifKey, value);

  bool getOnboardingFait() =>
      prefs.getBool(AppConstants.prefOnboardingFaitKey) ?? false;

  Future<void> setOnboardingFait(bool value) =>
      prefs.setBool(AppConstants.prefOnboardingFaitKey, value);
}
