import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF7B5556);
  static const Color primaryLight = Color(0xFFFDCBCB);
  static const Color primaryDark = Color(0xFF5A3D3E);

  // Background
  static const Color background = Color(0xFFFBF9F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F0EE);

  // Text
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF5F5F5F);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Accent
  static const Color accent = Color(0xFFE3F8CC);
  static const Color accentDark = Color(0xFF6B8F4A);

  // Promo
  static const Color promoBg = Color(0xFFF2D5D5);
  static const Color promoTag = Color(0xFFD4E8B8);

  // Rating
  static const Color starYellow = Color(0xFFF5C518);

  // Divider
  static const Color divider = Color(0xFFE8E3E0);

  // Misc
  static const Color shadow = Color(0x1F7B5556);
  static const Color iconDefault = Color(0xFF7B5556);
  static const Color chipBg = Color(0xFFF5F0EE);
  static const Color chipSelected = Color(0xFF7B5556);

  // Gradient
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFBF9F8), Color(0xFFFDCBCB)],
  );

  static const LinearGradient promoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF2D5D5), Color(0xFFE8C4C4)],
  );
}
