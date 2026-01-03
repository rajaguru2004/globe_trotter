import 'package:flutter/material.dart';

/// App color palette - Travel inspired theme
class AppColors {
  AppColors._();

  // Primary Colors - Ocean & Sky
  static const Color primaryBlue = Color(0xFF0083B0);
  static const Color primaryTeal = Color(0xFF00B4DB);
  static const Color primaryDark = Color(0xFF006080);

  // Accent Colors - Sunset
  static const Color accentOrange = Color(0xFFFF6B6B);
  static const Color accentYellow = Color(0xFFFFA502);
  static const Color accentPink = Color(0xFFFF8B94);

  // Neutral Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textHint = Color(0xFFB2BEC3);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF00B894);
  static const Color error = Color(0xFFD63031);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color info = Color(0xFF74B9FF);

  // Trip Status Colors
  static const Color statusUpcoming = Color(0xFF6C5CE7);
  static const Color statusOngoing = Color(0xFF00B894);
  static const Color statusCompleted = Color(0xFF636E72);
  static const Color statusDraft = Color(0xFFFDCB6E);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryTeal, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [accentOrange, accentYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
}
