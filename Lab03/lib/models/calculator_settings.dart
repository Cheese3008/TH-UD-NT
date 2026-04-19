import 'package:flutter/material.dart';

class CalculatorSettings {
  final ThemeMode themeMode;
  final int decimalPrecision;
  final bool isDegreeMode;
  final bool hapticFeedback;
  final bool soundEffects;
  final int historySize;

  CalculatorSettings({
    required this.themeMode,
    required this.decimalPrecision,
    required this.isDegreeMode,
    required this.hapticFeedback,
    required this.soundEffects,
    required this.historySize,
  });

  factory CalculatorSettings.defaultSettings() {
    return CalculatorSettings(
      themeMode: ThemeMode.system,
      decimalPrecision: 4,
      isDegreeMode: true,
      hapticFeedback: true,
      soundEffects: false,
      historySize: 50,
    );
  }
}