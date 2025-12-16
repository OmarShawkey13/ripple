import 'package:flutter/material.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';

class ColorsManager {
  static bool get isDark => homeCubit.isDarkMode;

  // -------- PRIMARY COLORS (Ripple Identity) -------- //
  static const Color primary = Color(0xFF3C78FF); // Ripple Blue
  static const Color secondary = Color(0xFF7B61FF); // Soft Violet
  static const Color accent = Color(0xFF00D6C9); // Aqua / Teal highlight

  // -------- LIGHT THEME -------- //
  static const Color lightBackground = Color(0xFFF7FAFF); // off-white blueish
  static const Color lightCard = Colors.white;
  static const Color lightTextPrimary = Color(0xFF101213);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // -------- DARK THEME -------- //
  static const Color darkBackground = Color(0xFF0D0F14);
  static const Color darkCard = Color(0xFF1A1C23);
  static const Color darkTextPrimary = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);

  // -------- SHARED -------- //
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA000);

  // -------- THEME COLORS -------- //
  static Color get textColor => isDark ? darkTextPrimary : lightTextPrimary;

  static Color get backgroundColor => isDark ? darkBackground : lightBackground;

  static Color get cardColor => isDark ? darkCard : lightCard;

  static Color get textSecondaryColor =>
      isDark ? darkTextSecondary : lightTextSecondary;

  static Color get iconColor => isDark ? darkTextPrimary : lightTextPrimary;

  static Color get iconSecondaryColor =>
      isDark ? darkTextSecondary : lightTextSecondary;
}
