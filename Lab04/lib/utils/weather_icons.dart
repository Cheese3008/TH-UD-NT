import 'package:flutter/material.dart';

class WeatherIcons {
  static IconData getIcon(String condition) {
    final String value = condition.toLowerCase();

    if (value.contains('clear')) {
      return Icons.wb_sunny_rounded;
    }

    if (value.contains('cloud')) {
      return Icons.cloud_rounded;
    }

    if (value.contains('rain') || value.contains('drizzle')) {
      return Icons.water_drop_rounded;
    }

    if (value.contains('thunderstorm')) {
      return Icons.thunderstorm_rounded;
    }

    if (value.contains('snow')) {
      return Icons.ac_unit_rounded;
    }

    if (value.contains('mist') ||
        value.contains('fog') ||
        value.contains('haze')) {
      return Icons.foggy;
    }

    return Icons.cloud_queue_rounded;
  }

  static List<Color> getGradientColors(
    String condition, {
    bool isNight = false,
  }) {
    final String value = condition.toLowerCase();

    if (isNight) {
      return [const Color(0xFF1A202C), const Color(0xFF2D3748)];
    }

    if (value.contains('clear')) {
      return [const Color(0xFF4A90E2), const Color(0xFF87CEEB)];
    }

    if (value.contains('rain') || value.contains('drizzle')) {
      return [const Color(0xFF4A5568), const Color(0xFF718096)];
    }

    if (value.contains('cloud')) {
      return [const Color(0xFF718096), const Color(0xFFCBD5E0)];
    }

    if (value.contains('thunderstorm')) {
      return [const Color(0xFF2D3748), const Color(0xFF4A5568)];
    }

    return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
  }
}
