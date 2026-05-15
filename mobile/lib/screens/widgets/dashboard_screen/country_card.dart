import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

class CountryData {
  const CountryData({
    required this.flag,
    required this.name,
    required this.code,
    required this.pending,
    required this.news,
    required this.accentColor,
    this.onTap,
  });

  final String flag;
  final String name;
  final String code;
  final int pending;
  final int news;
  final Color accentColor;
  final VoidCallback? onTap;
}

/// Tarjeta de país con barra lateral de color único por nación.
class CountryCard extends StatelessWidget {
  const CountryCard({super.key, required this.data});

  final CountryData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.fieldBorder, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Barra lateral de color
                Container(width: 4, color: data.accentColor),
                // Contenido
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 11,
                    ),
                    child: Row(
                      children: [
                        Text(data.flag, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.fieldText,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${data.pending} pendientes · ${data.news} noticias',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildCodeBadge(),
                            const SizedBox(height: 4),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 16,
                              color: AppColors.fieldBorder,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.fieldBorder, width: 0.5),
      ),
      child: Text(
        data.code,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}