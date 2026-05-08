import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

/// Sección superior del login: logo con anillos,
/// nombre de la fundación, tagline y badge de versión.
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 0),
      child: Column(
        children: [
          _buildLogo(),
          const SizedBox(height: 18),
          _buildTitle(),
          const SizedBox(height: 5),
          _buildTagline(),
          const SizedBox(height: 12),
          _buildVersionBadge(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Anillo exterior difuso
        Container(
          width: 102,
          height: 102,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.purpleGlow.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        // Caja del logo
        Container(
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.white.withOpacity(0.07),
            border: Border.all(
              color: AppColors.white.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.language_rounded,
            size: 40,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Latinoamérica Comparte',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildTagline() {
    return Text(
      'PANEL ADMINISTRATIVO MULTIPAÍS',
      style: TextStyle(
        color: AppColors.white.withOpacity(0.35),
        fontSize: 10,
        letterSpacing: 2.5,
      ),
    );
  }

  Widget _buildVersionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.purpleGlow.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.purpleGlow.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, size: 12, color: AppColors.purpleLilac),
          SizedBox(width: 5),
          Text(
            'CMS Admin v1.0',
            style: TextStyle(
              color: AppColors.purpleLilac,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}