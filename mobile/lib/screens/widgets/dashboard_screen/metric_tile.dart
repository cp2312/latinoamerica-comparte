import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

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
    final border    = dark ? null : Border.all(color: AppColors.fieldBorder, width: 0.5);
    final iconColor = dark ? Colors.white.withOpacity(0.50) : AppColors.primary;
    final numColor  = dark ? Colors.white : AppColors.primaryDark;
    final lblColor  = dark ? Colors.white.withOpacity(0.60) : AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: dark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.heroTop, AppColors.heroMid1],
              )
            : null,
        color: dark ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: border,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(dark ? 0.25 : 0.07),
            blurRadius: dark ? 20 : 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Icon(icon, size: 22, color: iconColor),
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dark
                        ? Colors.white.withOpacity(0.08)
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
              fontWeight: FontWeight.w600,
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