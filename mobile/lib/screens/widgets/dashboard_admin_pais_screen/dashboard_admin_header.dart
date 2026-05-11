import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

class DashboardAdminHeader extends StatelessWidget {
  final String nombre;
  final String rol;
  final String pais;
  final String bandera;

  const DashboardAdminHeader({
    super.key,
    required this.nombre,
    required this.rol,
    required this.pais,
    required this.bandera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  bandera,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, $nombre 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Portal $pais — CMS Admin',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _InfoBadge(
                  icon:  Icons.verified_user_outlined,
                  label: 'Rol',
                  value: rol,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoBadge(
                  icon:  Icons.public_outlined,
                  label: 'País',
                  value: pais,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Widget interno ────────────────────────────────────────────────────────────

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;

  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color:        Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color:      Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize:   13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}