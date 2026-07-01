import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyThemeMode = 'pref_theme_mode';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(_keyThemeMode, mode);
  }

  String getThemeMode() {
    return _prefs.getString(_keyThemeMode) ?? 'dark';
  }
}
