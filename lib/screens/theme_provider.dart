import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Default to system settings, or explicitly ThemeMode.light / ThemeMode.dark
  ThemeMode _themeMode = ThemeMode.dark; 

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // This tells Flutter to rebuild the entire app tree
  }
}