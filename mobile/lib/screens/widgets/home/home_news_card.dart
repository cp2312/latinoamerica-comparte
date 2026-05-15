import 'package:flutter/material.dart';
import 'package:mobile/screens/models/news_model.dart';

class HomeNewsCard extends StatelessWidget {
  final NewsModel noticia;

  const HomeNewsCard({super.key, required this.noticia});

  String get _logoAsset {
    switch (noticia.country.toLowerCase()) {
      case 'colombia':  return 'assets/images/logo_colombia.png';
      case 'chile':     return 'assets/images/logo_chile.png';
      case 'ecuador':   return 'assets/images/logo_ecuador.png';
      case 'argentina': return 'assets/images/logo_argentina.png';
      default:          return 'assets/images/logo_latam.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset:     const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── País con logo oficial ────────────────────────────────────
            Row(
              children: [
                Image.asset(
                  _logoAsset,
                  width:  22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 6),
                Text(
                  noticia.country,
                  style: const TextStyle(
                    fontSize: 12,
                    color:    Colors.black45,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Título ──────────────────────────────────────────────────
            Text(
              noticia.title,
              maxLines:  3,
              overflow:  TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize:   14,
                fontWeight: FontWeight.bold,
                color:      Color(0xFF2E2E2E),
                height:     1.4,
              ),
            ),

            const Spacer(),

            // ── Badge publicado ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color:        const Color(0xFF6A0080).withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'PUBLICADO',
                style: TextStyle(
                  fontSize:   10,
                  fontWeight: FontWeight.w700,
                  color:      Color(0xFF6A0080),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}