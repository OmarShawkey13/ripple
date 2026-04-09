import 'package:flutter/material.dart';
import 'package:ripple/core/utils/cubit/theme/theme_cubit.dart';

class ColorsManager {
  static bool get isDark => themeCubit.isDarkMode;

  // -------- BRAND COLORS (Material 3 Masterpiece - Premium Selection) -------- //
  static const Color primary = Color(0xFF0061FF); // Ripple Elite Blue
  static const Color secondary = Color(0xFF7C3AED); // Royal Vivid Violet
  static const Color tertiary = Color(0xFF06B6D4); // Electric Cyan
  static const Color accent = Color(0xFFF43F5E); // Premium Rose Accent

  // -------- LIGHT THEME (Sophisticated & Clean) -------- //
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceContainer = Color(0xFFF1F5F9); // Slate 100
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF475569); // Slate 600
  static const Color lightOutline = Color(0xFFE2E8F0); // Slate 200

  // -------- DARK THEME (Deep Obsidian & Elegant) -------- //
  static const Color darkBackground = Color(0xFF030712); // Deepest Obsidian
  static const Color darkSurface = Color(0xFF0F172A); // Slate 900
  static const Color darkSurfaceContainer = Color(0xFF1E293B); // Slate 800
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkOutline = Color(0xFF334155); // Slate 700

  // -------- STATUS COLORS (M3 Semantic) -------- //
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color error = Color(0xFFEF4444); // Rose 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500

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

  static Color get shadowColor => isDark
      ? Colors.black.withValues(alpha: 0.5)
      : const Color(0xFF0F172A).withValues(alpha: 0.08);

  static Color get surfaceTint => primary.withValues(alpha: 0.05);
}
