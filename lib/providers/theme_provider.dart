import 'package:flutter/material.dart';
import '../core/storage/preferences_service.dart';

class ThemeProvider extends ChangeNotifier {
  final PreferencesService _prefsService;
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeProvider(this._prefsService) {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void _loadTheme() {
    final modeStr = _prefsService.getThemeMode();
    _themeMode = modeStr == 'light' ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  Future<void> updateTheme(ThemeMode mode) async {
    _themeMode = mode;
    await _prefsService.saveThemeMode(mode == ThemeMode.light ? 'light' : 'dark');
    notifyListeners();
  }
}
