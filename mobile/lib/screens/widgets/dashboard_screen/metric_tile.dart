import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

/// Tile de métrica con dos variantes:
/// [dark] = fondo rosado oscuro, [lite] = blanco con borde.
class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.dark = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final bg     = dark ? AppColors.heroBottom : Colors.white;
    final border = dark ? null : Border.all(color: AppColors.fieldBorder, width: 0.5);
    final iconColor  = dark ? Colors.white.withOpacity(0.45) : AppColors.primary;
    final numColor   = dark ? Colors.white : AppColors.primaryDark;
    final lblColor   = dark ? Colors.white.withOpacity(0.60) : AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícono con círculo de brillo decorativo
          Stack(
            children: [
              Icon(icon, size: 22, color: iconColor),
              Positioned(
                top: -6, right: -6,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dark
                        ? Colors.white.withOpacity(0.07)
                        : AppColors.primary.withOpacity(0.05),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: numColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: lblColor, height: 1.3),
          ),
        ],
      ),
    );
  }
}