import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService storageService;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider(this.storageService);

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final value = await storageService.loadString(StorageService.themeKey);
    if (value == 'light') {
      _themeMode = ThemeMode.light;
    } else if (value == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await storageService.saveString(StorageService.themeKey, value);
    notifyListeners();
  }
}