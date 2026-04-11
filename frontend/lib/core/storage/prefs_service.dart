import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  PrefsService({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _themeModKey = 'theme_mode';

  bool get isOnboardingComplete =>
      _prefs.getBool(_onboardingCompleteKey) ?? false;

  Future<void> setOnboardingComplete() async {
    await _prefs.setBool(_onboardingCompleteKey, true);
  }

  String get themeMode => _prefs.getString(_themeModKey) ?? 'system';

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_themeModKey, mode);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
