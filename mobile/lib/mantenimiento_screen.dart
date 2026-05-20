// lib/screens/widgets/mantenimiento_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/login_screen.dart';

class MantenimientoScreen extends StatelessWidget {
  const MantenimientoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // ── Ícono central ──────────────────────────────────────────
              Container(
                width:  100,
                height: 100,
                decoration: BoxDecoration(
                  color:        const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color(0xFFFCD34D),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.build_rounded,
                  size:  48,
                  color: Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(height: 32),

              // ── Título ─────────────────────────────────────────────────
              const Text(
                'Portal en mantenimiento',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:   22,
                  fontWeight: FontWeight.w700,
                  color:      Color(0xFF4A0030),
                ),
              ),
              const SizedBox(height: 12),

              // ── Descripción ────────────────────────────────────────────
              Text(
                'El portal de tu país está temporalmente '
                'desactivado por el equipo de administración.\n\n'
                'Por favor, contacta al superadministrador '
                'para más información.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color:    Colors.grey[600],
                  height:   1.6,
                ),
              ),
              const SizedBox(height: 40),

              // ── Banner informativo ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:        const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFFCD34D),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFFF59E0B),
                      size:  20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cuando el portal sea reactivado podrás '
                        'iniciar sesión normalmente.',
                        style: TextStyle(
                          fontSize: 13,
                          color:    Colors.orange[800],
                          height:   1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ── Botón volver al login ──────────────────────────────────
              SizedBox(
                width:  double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size:  18,
                    color: AppColors.primary,
                  ),
                  label: const Text(
                    'Volver al inicio de sesión',
                    style: TextStyle(
                      fontSize:   14,
                      fontWeight: FontWeight.w600,
                      color:      AppColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary, width: 1),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}