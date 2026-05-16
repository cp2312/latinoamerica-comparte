// lib/screens/widgets/solicitudes/solicitud_detalle_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/services/solicitudes_service.dart';

class SolicitudDetalleScreen extends StatefulWidget {
  final SolicitudModel solicitud;
  const SolicitudDetalleScreen({super.key, required this.solicitud});

  @override
  State<SolicitudDetalleScreen> createState() =>
      _SolicitudDetalleScreenState();
}

class _SolicitudDetalleScreenState extends State<SolicitudDetalleScreen> {
  final _service  = SolicitudesService();
  late String _estado;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _estado = widget.solicitud.estado;
  }

  Color _colorEstado(String e) => switch (e) {
        'pendiente'  => const Color(0xFFF59E0B),
        'gestionada' => const Color(0xFF3B82F6),
        'respondida' => const Color(0xFF10B981),
        _            => Colors.grey,
      };

  // ── Cambiar estado ─────────────────────────────────────────────────────────
  Future<void> _cambiarEstado(String nuevo) async {
    setState(() => _guardando = true);
    final ok = await _service.cambiarEstado(widget.solicitud.id, nuevo);
    if (!mounted) return;
    setState(() { _guardando = false; });
    if (ok) {
      setState(() => _estado = nuevo);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Estado actualizado'),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se pudo actualizar el estado'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  // ── Eliminar ───────────────────────────────────────────────────────────────
  Future<void> _confirmarEliminar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Eliminar solicitud',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            '¿Confirmas que deseas eliminar esta solicitud? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final eliminado = await _service.eliminar(widget.solicitud.id);
    if (!mounted) return;
    if (eliminado) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Solicitud eliminada'),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se pudo eliminar la solicitud'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final s     = widget.solicitud;
    final color = _colorEstado(_estado);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F8),
      appBar: AppBar(
        backgroundColor: AppColors.heroBottom,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Detalle de Solicitud',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline_rounded,
                color: Colors.red[200]),
            onPressed: _confirmarEliminar,
            tooltip: 'Eliminar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Encabezado ─────────────────────────────────────────────────
            _card(
              child: Row(children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: color.withOpacity(0.12),
                  child: Text(
                    s.nombre.isNotEmpty
                        ? s.nombre[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: 22),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.nombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: AppColors.fieldText)),
                      const SizedBox(height: 6),
                      _badge(_estado, color),
                    ],
                  ),
                ),
              ]),
            ),

            const SizedBox(height: 12),

            // ── Datos ──────────────────────────────────────────────────────
            _card(
              child: Column(children: [
                _fila(Icons.email_outlined,       'Correo',    s.correo),
                _div(),
                _fila(Icons.phone_outlined,       'Teléfono',  s.telefono),
                _div(),
                _fila(Icons.description_outlined, 'Finalidad', s.finalidad),
                _div(),
                _fila(Icons.location_on_outlined, 'País',
                    '${s.bandera}  ${s.pais}'),
                _div(),
                _fila(Icons.calendar_today_outlined, 'Fecha',
                    s.fechaFormateada.isEmpty ? '—' : s.fechaFormateada),
              ]),
            ),

            const SizedBox(height: 20),

            // ── Cambiar estado ─────────────────────────────────────────────
            const Text('Cambiar estado',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.fieldText)),
            const SizedBox(height: 10),

            if (_guardando)
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(16),
                child:
                    CircularProgressIndicator(color: AppColors.primary),
              ))
            else
              Row(children: [
                _btnEstado('pendiente',  'Pendiente',
                    Icons.hourglass_empty_rounded,
                    const Color(0xFFF59E0B)),
                const SizedBox(width: 8),
                _btnEstado('gestionada', 'Gestionada',
                    Icons.pending_actions_rounded,
                    const Color(0xFF3B82F6)),
                const SizedBox(width: 8),
                _btnEstado('respondida', 'Respondida',
                    Icons.check_circle_outline_rounded,
                    const Color(0xFF10B981)),
              ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Helpers de UI ──────────────────────────────────────────────────────────
  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.fieldBorder, width: 0.5),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.04),
            ),
          ],
        ),
        child: child,
      );

  Widget _badge(String texto, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(texto.toUpperCase(),
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 0.5)),
      );

  Widget _fila(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 17, color: AppColors.fieldLabel),
          const SizedBox(width: 12),
          SizedBox(
            width: 76,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.fieldLabel,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: AppColors.fieldText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
        ]),
      );

  Widget _div() => const Divider(
      height: 1, color: Color(0xFFFFF0F6));

  Widget _btnEstado(
      String estado, String label, IconData icon, Color color) {
    final activo = _estado == estado;
    return Expanded(
      child: GestureDetector(
        onTap: activo ? null : () => _cambiarEstado(estado),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: activo ? color : color.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: activo ? color : color.withOpacity(0.30),
              width: 1.5,
            ),
          ),
          child: Column(children: [
            Icon(icon,
                color: activo ? Colors.white : color, size: 22),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: activo ? Colors.white : color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }
}
