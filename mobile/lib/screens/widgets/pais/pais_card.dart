import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/screens/models/pais_model.dart';
 
/// Tarjeta de portal/país. Solo permite activar o desactivar.
/// No expone opciones de crear, editar ni eliminar.
class PaisCard extends StatelessWidget {
  const PaisCard({
    super.key,
    required this.pais,
    required this.onToggleEstado,
  });
 
  final PaisModel pais;
  final Future<void> Function(bool activo) onToggleEstado;
 
  // ── Colores y etiqueta según estado ───────────────────────────────────────
  Color get _colorEstado =>
      pais.estaActivo ? const Color(0xFF10B981) : const Color(0xFFF59E0B);
 
  Color get _bgEstado =>
      pais.estaActivo ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7);
 
  String get _labelEstado => pais.estaActivo ? 'Activo' : 'En mantenimiento';
 
  IconData get _iconEstado =>
      pais.estaActivo ? Icons.public_rounded : Icons.build_rounded;
 
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: pais.estaActivo
              ? const Color(0xFFF8BBD0)
              : const Color(0xFFFCD34D),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // ── Bandera y nombre ───────────────────────────────────────────
            Text(pais.bandera, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pais.nombre,
                    style: const TextStyle(
                      fontSize:   15,
                      fontWeight: FontWeight.w600,
                      color:      Color(0xFF4A0030),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Badge de estado
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:        _bgEstado,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_iconEstado, size: 11, color: _colorEstado),
                        const SizedBox(width: 4),
                        Text(
                          _labelEstado,
                          style: TextStyle(
                            fontSize:   11,
                            fontWeight: FontWeight.w600,
                            color:      _colorEstado,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
 
            // Switch — única acción disponible
            Switch(
              value:              pais.estaActivo,
              onChanged:          onToggleEstado,
              activeColor:        AppColors.primary,
              inactiveThumbColor: const Color(0xFFF59E0B),
              inactiveTrackColor: const Color(0xFFFEF3C7),
            ),
          ],
        ),
      ),
    );
  }
}
