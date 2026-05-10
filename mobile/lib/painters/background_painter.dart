import 'dart:math' as math;
import 'package:flutter/material.dart';


/// Pinta sobre el fondo: arcos decorativos superiores,
/// partículas/estrellas y anillos punteados alrededor del logo.
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawTopArcs(canvas, size);
    _drawStars(canvas, size);
    _drawLogoRings(canvas, size);
  }
 
  void _drawTopArcs(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
 
    paint.color = Colors.white.withOpacity(0.18);
    canvas.drawPath(
      Path()
        ..moveTo(0, -10)
        ..quadraticBezierTo(size.width / 2, size.height * 0.21, size.width, -10),
      paint,
    );
 
    paint.color = Colors.white.withOpacity(0.10);
    canvas.drawPath(
      Path()
        ..moveTo(-10, -10)
        ..quadraticBezierTo(size.width / 2, size.height * 0.25, size.width + 10, -10),
      paint,
    );
  }
 
  void _drawStars(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
 
    // [x%, y%, radius, opacity]
    const stars = [
      [0.13, 0.18, 1.5, 0.55],
      [0.83, 0.12, 1.0, 0.45],
      [0.62, 0.24, 1.5, 0.35],
      [0.20, 0.08, 1.0, 0.50],
      [0.91, 0.21, 1.0, 0.30],
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
    // Logo centrado al ~31% de la altura
    final center = Offset(size.width / 2, size.height * 0.31);
 
    _drawDashedCircle(canvas, center, 54,
        Colors.white.withOpacity(0.16), dashLen: 4, gapLen: 6);
    _drawDashedCircle(canvas, center, 68,
        Colors.white.withOpacity(0.09), dashLen: 2, gapLen: 10);
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
 
    final count = (2 * math.pi * radius / (dashLen + gapLen)).floor();
 
    for (int i = 0; i < count; i++) {
      final start = i * (dashLen + gapLen) / radius;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        dashLen / radius,
        false,
        paint,
      );
    }
  }
 
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}