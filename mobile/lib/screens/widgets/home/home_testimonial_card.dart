import 'package:flutter/material.dart';

class HomeTestimonialCard extends StatelessWidget {
  final String nombre;
  final String pais;
  final String texto;
  final String? fotoUrl;

  const HomeTestimonialCard({
    super.key,
    required this.nombre,
    required this.pais,
    required this.texto,
    this.fotoUrl,
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
      width: 260,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // ── SingleChildScrollView permite ver todo el texto si es largo ──────
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Comillas decorativas ────────────────────────────────────────
            const Icon(
              Icons.format_quote_rounded,
              color: Color(0xFF9C27B0),
              size: 28,
            ),

            const SizedBox(height: 6),

            // ── Texto SIN límite de líneas ni ellipsis ──────────────────────
            Text(
              texto,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF555555),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            // ── Autor con foto ──────────────────────────────────────────────
            Row(
              children: [
                _Avatar(nombre: nombre, fotoUrl: fotoUrl),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '$_bandera $pais',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatar: muestra foto si existe, inicial si no ─────────────────────────────
class _Avatar extends StatelessWidget {
  final String nombre;
  final String? fotoUrl;
  const _Avatar({required this.nombre, this.fotoUrl});

  @override
  Widget build(BuildContext context) {
    final tieneUrl = fotoUrl != null && fotoUrl!.isNotEmpty;

    if (tieneUrl) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFF9C27B0),
        backgroundImage: NetworkImage(fotoUrl!),
        onBackgroundImageError: (_, __) {},
        child: null,
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: const Color(0xFF9C27B0).withOpacity(0.15),
      child: Text(
        nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
        style: const TextStyle(
          color: Color(0xFF6A0080),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}