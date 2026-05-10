import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';


 
/// Sección superior del login: logo PNG con anillos decorativos,
/// nombre de la fundación, tagline y badge de versión.
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        children: [
          _buildLogo(),
          const SizedBox(height: 14),
          _buildTitle(),
          const SizedBox(height: 4),
          _buildTagline(),
          const SizedBox(height: 10),
          _buildVersionBadge(),
        ],
      ),
    );
  }
 
  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Anillo exterior punteado
        Container(
          width: 108,
          height: 108,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.28),
              width: 1,
            ),
          ),
        ),
        // Anillo interior
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1,
            ),
          ),
        ),
        // Contenedor del logo PNG
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
          
           
          ),
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            'assets/images/logo_latam1.png',
            fit: BoxFit.contain,
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
        color: AppColors.heroText,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
    );
  }
 
  Widget _buildTagline() {
    return Text(
      'PANEL ADMINISTRATIVO MULTIPAÍS',
      style: TextStyle(
        color: AppColors.heroSubText,
        fontSize: 10,
        letterSpacing: 2.2,
      ),
    );
  }
 
  Widget _buildVersionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.45),
          width: 0.5,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, size: 12, color: AppColors.heroText),
          SizedBox(width: 5),
          Text(
            'CMS Admin v1.0',
            style: TextStyle(
              color: AppColors.heroText,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}