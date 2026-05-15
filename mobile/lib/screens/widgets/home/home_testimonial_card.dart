import 'package:flutter/material.dart';

class HomeTestimonialCard extends StatelessWidget {
  final String nombre;
  final String pais;
  final String texto;

  const HomeTestimonialCard({
    super.key,
    required this.nombre,
    required this.pais,
    required this.texto,
  });

  String get _bandera {
    switch (pais.toLowerCase()) {
      case 'colombia':  return '🇨🇴';
      case 'chile':     return '🇨🇱';
      case 'ecuador':   return '🇪🇨';
      case 'argentina': return '🇦🇷';
      default:          return '🌎';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Comillas decorativas ────────────────────────────────────
          const Icon(
            Icons.format_quote_rounded,
            color: Color(0xFF9C27B0),
            size:  28,
          ),

          const SizedBox(height: 6),

          // ── Texto ───────────────────────────────────────────────────
          Expanded(
            child: Text(
              texto,
              maxLines:  4,
              overflow:  TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color:    Color(0xFF555555),
                height:   1.5,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Autor ───────────────────────────────────────────────────
          Row(
            children: [
              CircleAvatar(
                radius:          16,
                backgroundColor: const Color(0xFF9C27B0).withOpacity(0.15),
                child: Text(
                  nombre.substring(0, 1),
                  style: const TextStyle(
                    color:      Color(0xFF6A0080),
                    fontWeight: FontWeight.bold,
                    fontSize:   14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize:   12,
                      ),
                    ),
                    Text(
                      '$_bandera $pais',
                      style: const TextStyle(
                        fontSize: 11,
                        color:    Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}