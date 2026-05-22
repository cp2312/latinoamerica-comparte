import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Fondo general ──
  static const background     = Colors.white;
  static const scaffoldBg     = Color(0xFFF5F0FF);

  // ── Gradiente Hero ──
  static const heroTop        = Color(0xFF3B1F6E);
  static const heroMid1       = Color(0xFF6B3FA0);
  static const heroMid2       = Color(0xFF7E57C2);
  static const heroBottom     = Color(0xFF4A2580);

  // ── Morado principal / Botones ──
  static const primary        = Color(0xFF7B3FA0);
  static const primaryDark    = Color(0xFF3B1F6E);
  static const primaryLight   = Color(0xFFD1C4E9);

  // ── Campos ──
  static const fieldBg        = Color(0xFFF3EEFF);
  static const fieldBorder    = Color(0xFFD1C4E9);
  static const fieldFocused   = Color(0xFF7B3FA0);
  static const fieldIcon      = Color(0xFF7B3FA0);
  static const fieldText      = Color(0xFF3B1F6E);
  static const fieldLabel     = Color(0xFF6B3FA0);

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
  static const activityPend      = Color(0xFFF3EEFF);
  static const activityPub       = Color(0xFFE8F5E9);
  static const activityTest      = Color(0xFFE3F2FD);

  static const activityPendIcon  = Color(0xFF7B3FA0);
  static const activityPubIcon   = Color(0xFF388E3C);
  static const activityTestIcon  = Color(0xFF1976D2);

  // ── Colores SVG Logo ──
  static const logoRed        = Color(0xFFE57373);
  static const logoBlue       = Color(0xFF64B5F6);
  static const logoOrange     = Color(0xFFFF8A65);
  static const logoPurple     = Color(0xFF8B1DB8);
}