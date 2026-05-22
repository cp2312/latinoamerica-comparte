import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    this.userRole = 'Superadmin',
    this.country = 'Global',
  });

  final String userRole;
  final String country;

  String get _initials {
    final p = userRole.trim().split(' ');
    return p.length >= 2
        ? '${p[0][0]}${p[1][0]}'.toUpperCase()
        : userRole.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.heroTop,
              AppColors.heroMid1,
              AppColors.heroMid2,
            ],
          ),
        ),
        padding: EdgeInsets.fromLTRB(20, top + 14, 20, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusBar(),
            const SizedBox(height: 14),
            _buildMainRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'PANEL ADMINISTRATIVO',
          style: TextStyle(
            color: Colors.white.withOpacity(0.50),
            fontSize: 10,
            letterSpacing: 1.8,
          ),
        ),
        Row(
          children: [
            Icon(Icons.wifi, size: 13, color: Colors.white.withOpacity(0.70)),
            const SizedBox(width: 4),
            Icon(Icons.battery_full_rounded, size: 13,
                color: Colors.white.withOpacity(0.70)),
          ],
        ),
      ],
    );
  }

  Widget _buildMainRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenido 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildChip(Icons.verified_user_outlined, userRole),
                  const SizedBox(width: 8),
                  _buildChip(Icons.public_outlined, country),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildAvatar(),
      ],
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.30),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 11, color: Colors.white.withOpacity(0.85)),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.20),
            border: Border.all(
              color: Colors.white.withOpacity(0.40),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              _initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 22)
      ..quadraticBezierTo(
        size.width / 2, size.height + 16,
        size.width, size.height - 22,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}