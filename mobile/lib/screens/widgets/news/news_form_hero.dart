import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';


class NewsFormHero extends StatelessWidget {
  const NewsFormHero({
    super.key,
    required this.screenTitle,
    required this.newsTitle,
    required this.subtitle,
  });

  final String screenTitle;
  final String newsTitle;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.heroBottom,
      padding: EdgeInsets.fromLTRB(18, top + 14, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status bar simulado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Row(
                children: [
                  Icon(Icons.wifi, size: 13,
                      color: Colors.white.withOpacity(0.70)),
                  const SizedBox(width: 4),
                  Icon(Icons.battery_full_rounded, size: 13,
                      color: Colors.white.withOpacity(0.70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Botón volver + título de pantalla
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                screenTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Título y subtítulo
          Text(
            newsTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.60),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}