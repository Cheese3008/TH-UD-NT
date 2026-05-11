import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF8B5CF6);
  static const Color secondary = Color(0xFF22D3EE);
  static const Color accent = Color(0xFFFFA726);

  static const Color background = Color(0xFF090B18);
  static const Color surface = Color(0xFF111428);
  static const Color card = Color(0xFF181B33);
  static const Color cardSoft = Color(0xFF222645);

  static const Color text = Color(0xFFF8FAFC);
  static const Color mutedText = Color(0xFF9CA3AF);
  static const Color border = Color(0xFF2F3458);
}

class AppSpacing {
  static const double screenPadding = 18;
  static const double miniPlayerHeight = 94;
  static const double borderRadius = 24;
}

class AppGradients {
  static const LinearGradient background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF151936),
      Color(0xFF090B18),
      Color(0xFF111827),
    ],
  );

  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.secondary,
    ],
  );

  static const LinearGradient warm = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFA726),
      Color(0xFFFF5C8A),
    ],
  );
}

class AppShadows {
  static List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withOpacity(0.24),
      blurRadius: 24,
      offset: const Offset(0, 14),
    ),
  ];
}
