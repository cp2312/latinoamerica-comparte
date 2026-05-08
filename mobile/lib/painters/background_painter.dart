import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Dibuja las líneas diagonales, estrellas y
/// anillos punteados detrás del logo.
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawDiagonalLines(canvas, size);
    _drawTopArc(canvas, size);
    _drawStars(canvas, size);
    _drawLogoRings(canvas, size);
  }

  void _drawDiagonalLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    paint.color = AppColors.purpleGlow.withOpacity(0.07);
    canvas.drawLine(
      Offset(0, size.height * 0.32),
      Offset(size.width, size.height * 0.61),
      paint,
    );

    paint.color = AppColors.purpleGlow.withOpacity(0.05);
    canvas.drawLine(
      Offset(size.width, size.height * 0.26),
      Offset(0, size.height * 0.55),
      paint,
    );
  }

  void _drawTopArc(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.purpleGlow.withOpacity(0.12)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, -20)
      ..quadraticBezierTo(size.width / 2, size.height * 0.19, size.width, -20);

    canvas.drawPath(path, paint);
  }

  void _drawStars(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // [x%, y%, radius, opacity]
    final stars = [
      [0.13, 0.18, 1.5, 0.50],
      [0.80, 0.12, 1.0, 0.40],
      [0.60, 0.25, 1.5, 0.30],
      [0.20, 0.51, 1.0, 0.35],
      [0.87, 0.67, 1.5, 0.25],
      [0.50, 0.08, 1.0, 0.60],
      [0.90, 0.48, 1.0, 0.30],
    ];

    for (final s in stars) {
      paint.color = Colors.white.withOpacity(s[3]);
      canvas.drawCircle(
        Offset(size.width * s[0], size.height * s[1]),
        s[2],
        paint,
      );
    }
  }

  void _drawLogoRings(Canvas canvas, Size size) {
    // El logo está aproximadamente al 26% de la altura
    final center = Offset(size.width / 2, size.height * 0.255);

    _drawDashedCircle(
      canvas, center, 72,
      AppColors.purpleGlow.withOpacity(0.12),
      dashLen: 4, gapLen: 6,
    );
    _drawDashedCircle(
      canvas, center, 90,
      AppColors.purpleGlow.withOpacity(0.07),
      dashLen: 2, gapLen: 10,
    );
  }

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Color color, {
    required double dashLen,
    required double gapLen,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final circumference = 2 * math.pi * radius;
    final count = (circumference / (dashLen + gapLen)).floor();

    for (int i = 0; i < count; i++) {
      final startAngle = (i * (dashLen + gapLen)) / radius;
      final sweepAngle = dashLen / radius;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}