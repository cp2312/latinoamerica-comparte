import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Fondo general ──
  static const background     = Colors.white;
  static const scaffoldBg     = Color(0xFFFDF5F8);

  // ── Gradiente Hero ──
  static const heroTop        = Color(0xFFB5004E);
  static const heroMid1       = Color(0xFFD81B60);
  static const heroMid2       = Color(0xFFAD1457);
  static const heroBottom     = Color(0xFF880E4F);

  // ── Rosado principal / Botones ──
  static const primary        = Color(0xFFC2185B);
  static const primaryDark    = Color(0xFF880E4F);
  static const primaryLight   = Color(0xFFF8BBD0);

  // ── Campos / Login ──
  static const fieldBg        = Color(0xFFFFF0F6);
  static const fieldBorder    = Color(0xFFF8BBD0);
  static const fieldFocused   = Color(0xFFD81B60);
  static const fieldIcon      = Color(0xFFD81B60);
  static const fieldText      = Color(0xFF4A0030);
  static const fieldLabel     = Color(0xFFAD1457);

  // ── Textos sobre Hero ──
  static const heroText       = Colors.white;
  static const heroSubText    = Color(0xB3FFFFFF);

  // ── Logo y badges ──
  static const logoBg         = Color(0x38FFFFFF);
  static const logoBorder     = Color(0x66FFFFFF);

  // ── Cards por país ──
  static const countryBorderCo = Color(0xFFFFA000);
  static const countryBorderCl = Color(0xFF1976D2);
  static const countryBorderEc = Color(0xFF388E3C);

  // ── Actividades ──
  static const activityPend      = Color(0xFFFFF0F6);
  static const activityPub       = Color(0xFFE8F5E9);
  static const activityTest      = Color(0xFFE3F2FD);

  static const activityPendIcon  = Color(0xFFC2185B);
  static const activityPubIcon   = Color(0xFF388E3C);
  static const activityTestIcon  = Color(0xFF1976D2);

  // ── Colores SVG Logo ──
  static const logoRed        = Color(0xFFE57373);
  static const logoBlue       = Color(0xFF64B5F6);
  static const logoOrange     = Color(0xFFFF8A65);
  static const logoPurple     = Color(0xFF8B1DB8);
}