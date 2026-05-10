import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/painters/background_painter.dart';

 
/// Capa de fondo: gradiente rosado oscuro → blanco,
/// nebulosas radiales, ola blanca inferior y decoración pintada.
class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildGradient(),
        _buildNebula(top: -110, size: 320, opacity: 0.30),
        _buildNebula(
          bottom: 160,
          right: -40,
          size: 180,
          color: AppColors.heroMid2,
          opacity: 0.25,
        ),
        _buildBottomWave(),
        Positioned.fill(
          child: CustomPaint(painter: BackgroundPainter()),
        ),
      ],
    );
  }
 
  Widget _buildGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.9),
          radius: 1.3,
          colors: [
            AppColors.heroTop,
            AppColors.heroMid1,
            AppColors.heroMid2,
            AppColors.heroBottom,
            Colors.white,
          ],
          stops: [0.0, 0.18, 0.38, 0.55, 0.75],
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
    Color color = AppColors.heroMid1,
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
 
  Widget _buildBottomWave() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 370,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.elliptical(double.infinity, 28),
          ),
        ),
      ),
    );
  }
}