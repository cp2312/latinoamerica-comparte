import 'package:flutter/material.dart';

abstract class AppColors {
  // Fondo
  static const background = Colors.white;

  // Gradiente hero (rosa oscuro → blanco)
  static const heroTop        = Color(0xFFB5004E);
  static const heroMid1       = Color(0xFFD81B60);
  static const heroMid2       = Color(0xFFAD1457);
  static const heroBottom     = Color(0xFF880E4F);

  // Acento / botón
  static const primary        = Color(0xFFC2185B);
  static const primaryDark    = Color(0xFF880E4F);
  static const primaryLight   = Color(0xFFF8BBD0);

  // Campos
  static const fieldBg        = Color(0xFFFFF0F6);
  static const fieldBorder    = Color(0xFFF8BBD0);
  static const fieldFocused   = Color(0xFFD81B60);
  static const fieldIcon      = Color(0xFFD81B60);
  static const fieldText      = Color(0xFF4A0030);
  static const fieldLabel     = Color(0xFFAD1457);

  // Textos sobre hero
  static const heroText       = Colors.white;
  static const heroSubText    = Color(0xB3FFFFFF); // 70% blanco

  // Logo y badges sobre hero
  static const logoBg         = Color(0x38FFFFFF); // 22% blanco
  static const logoBorder     = Color(0x66FFFFFF); // 40% blanco

  // Colores del logo SVG (mapa de Latinoamérica)
  static const logoRed        = Color(0xFFE57373);
  static const logoBlue       = Color(0xFF64B5F6);
  static const logoOrange     = Color(0xFFFF8A65);
  static const logoPurple     = Color(0xFF8B1DB8);
}