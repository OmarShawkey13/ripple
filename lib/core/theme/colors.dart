import 'package:flutter/material.dart';
import 'package:ripple/core/utils/cubit/theme/theme_cubit.dart';

class ColorsManager {
  static bool get isDark => themeCubit.isDarkMode;

  // -------- BRAND COLORS (Material 3 Masterpiece) -------- //
  static const Color primary = Color(0xFF3C78FF); // Ripple Vibrant Blue
  static const Color secondary = Color(0xFF6366F1); // Indigo / Violet
  static const Color tertiary = Color(0xFF0EA5E9); // Sky / Aqua

  // -------- LIGHT THEME (Clean & Crisp) -------- //
  static const Color lightBackground = Color(
    0xFFF8FAFC,
  ); // Very light blueish gray
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceContainer = Color(
    0xFFF1F5F9,
  ); // Lighter gray for cards
  static const Color lightTextPrimary = Color(
    0xFF0F172A,
  ); // Deep slate for text
  static const Color lightTextSecondary = Color(
    0xFF64748B,
  ); // Cool gray for sub-text
  static const Color lightOutline = Color(0xFFE2E8F0); // Subtle borders

  // -------- DARK THEME (Deep & Elegant) -------- //
  static const Color darkBackground = Color(0xFF020617); // Deepest Navy
  static const Color darkSurface = Color(0xFF0F172A); // Surface Blue-Black
  static const Color darkSurfaceContainer = Color(0xFF1E293B); // Card Slate
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Off-white
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Muted Slate
  static const Color darkOutline = Color(0xFF334155); // Dark Slate borders

  // -------- STATUS COLORS (M3 Semantic) -------- //
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color error = Color(0xFFEF4444); // Rose Red
  static const Color warning = Color(0xFFF59E0B); // Amber Orange

  // -------- ADAPTIVE GETTERS (The Only Way To Access Colors) -------- //

  static Color get textColor => isDark ? darkTextPrimary : lightTextPrimary;

  static Color get textSecondaryColor =>
      isDark ? darkTextSecondary : lightTextSecondary;

  static Color get backgroundColor => isDark ? darkBackground : lightBackground;

  static Color get cardColor => isDark ? darkSurface : lightSurface;

  static Color get surfaceContainer =>
      isDark ? darkSurfaceContainer : lightSurfaceContainer;

  static Color get outline => isDark ? darkOutline : lightOutline;

  static Color get dividerColor => isDark ? darkOutline : lightOutline;

  static Color get iconColor => isDark ? darkTextPrimary : lightTextPrimary;

  static Color get iconSecondaryColor =>
      isDark ? darkTextSecondary : lightTextSecondary;
}
