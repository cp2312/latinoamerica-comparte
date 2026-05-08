import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/painters/background_painter.dart';

/// Capa visual de fondo: gradientes de nebulosa +
/// decoración pintada (líneas, estrellas, anillos).
class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBaseGradient(),
        _buildNebula(top: -120, size: 340, opacity: 0.28),
        _buildNebula(bottom: 100, left: -60, size: 220,
            color: const Color(0xFF6400C8), opacity: 0.35),
        _buildNebula(bottom: 200, right: -30, size: 160,
            color: const Color(0xFFDC64FF), opacity: 0.18),
        Positioned.fill(
          child: CustomPaint(painter: BackgroundPainter()),
        ),
      ],
    );
  }

  Widget _buildBaseGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.85),
          radius: 1.2,
          colors: [
            AppColors.purpleMid,
            AppColors.purpleDeep,
            AppColors.background,
          ],
          stops: [0.0, 0.45, 0.85],
        ),
      ),
    );
  }

  Widget _buildNebula({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    Color color = AppColors.purpleGlow,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withOpacity(opacity), Colors.transparent],
          ),
        ),
      ),
    );
  }
}