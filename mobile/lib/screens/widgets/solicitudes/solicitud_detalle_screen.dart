import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/services/solicitudes_service.dart';

class SolicitudDetalleScreen extends StatefulWidget {
  final SolicitudModel solicitud;
  const SolicitudDetalleScreen({super.key, required this.solicitud});

  @override
  State<SolicitudDetalleScreen> createState() => _SolicitudDetalleScreenState();
}

class _SolicitudDetalleScreenState extends State<SolicitudDetalleScreen> {
  final _service     = SolicitudesService();
  final _msgCtrl     = TextEditingController();
  late String _estado;
  bool _guardando    = false;
  bool _enviandoMail = false;

  @override
  void initState() {
    super.initState();
    _estado = widget.solicitud.estado;
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  Color _colorEstado(String e) => switch (e) {
    'pendiente'  => const Color(0xFFF59E0B),
    'gestionada' => const Color(0xFF3B82F6),
    'respondida' => const Color(0xFF10B981),
    _            => Colors.grey,
  };

  // ── Cambiar estado ──────────────────────────────────────────────────────────
  Future<void> _cambiarEstado(String nuevo) async {
    setState(() => _guardando = true);
    final ok = await _service.cambiarEstado(widget.solicitud.id, nuevo);
    if (!mounted) return;
    setState(() { _guardando = false; });
    if (ok) {
      setState(() => _estado = nuevo);
      _snack('Estado actualizado', const Color(0xFF10B981));
    } else {
      _snack('No se pudo actualizar el estado', Colors.red);
    }
  }

  // ── Responder por correo ────────────────────────────────────────────────────
  Future<void> _responder() async {
    final mensaje = _msgCtrl.text.trim();
    if (mensaje.isEmpty) {
      _snack('Escribe un mensaje antes de enviar', const Color(0xFFF59E0B));
      return;
    }

    // Confirmar envío
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Enviar respuesta',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text(
          'Se enviará un correo a:\n${widget.solicitud.correo}\n\n'
          'El estado cambiará automáticamente a "Respondida".',
          style: const TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            icon:  const Icon(Icons.send_rounded, size: 16),
            label: const Text('Enviar correo'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() => _enviandoMail = true);
    final RespuestaEnvio result = await _service.responder(widget.solicitud.id, mensaje);
    if (!mounted) return;
    setState(() {
      _enviandoMail = false;
      if (result.ok) _estado = 'respondida';
    });

    if (result.ok) {
      _msgCtrl.clear();
      _snack('✅ Correo enviado a ${widget.solicitud.correo}',
          const Color(0xFF10B981));
    } else {
      _snack('❌ ${result.mensaje}', Colors.red);
    }
  }

  // ── Eliminar ────────────────────────────────────────────────────────────────
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
      _snack('Solicitud eliminada', const Color(0xFF10B981));
    } else {
      _snack('No se pudo eliminar la solicitud', Colors.red);
    }
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ));
  }

  // ── Build ───────────────────────────────────────────────────────────────────
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
            icon: Icon(Icons.delete_outline_rounded, color: Colors.red[200]),
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

            // ── Encabezado ──────────────────────────────────────────────────
            _card(child: Row(children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.12),
                child: Text(
                  s.nombre.isNotEmpty ? s.nombre[0].toUpperCase() : '?',
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w800, fontSize: 22),
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
            ])),

            const SizedBox(height: 12),

            // ── Datos ────────────────────────────────────────────────────────
            _card(child: Column(children: [
              _fila(Icons.email_outlined,          'Correo',    s.correo),
              _div(),
              _fila(Icons.phone_outlined,          'Teléfono',  s.telefono),
              _div(),
              _fila(Icons.description_outlined,    'Finalidad', s.finalidad),
              _div(),
              _fila(Icons.location_on_outlined,    'País',      '${s.bandera}  ${s.pais}'),
              _div(),
              _fila(Icons.calendar_today_outlined, 'Fecha',
                  s.fechaFormateada.isEmpty ? '—' : s.fechaFormateada),
            ])),

            const SizedBox(height: 20),

            // ── Cambiar estado ───────────────────────────────────────────────
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
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else
              Row(children: [
                _btnEstado('pendiente',  'Pendiente',
                    Icons.hourglass_empty_rounded,  const Color(0xFFF59E0B)),
                const SizedBox(width: 8),
                _btnEstado('gestionada', 'Gestionada',
                    Icons.pending_actions_rounded,  const Color(0xFF3B82F6)),
                const SizedBox(width: 8),
                _btnEstado('respondida', 'Respondida',
                    Icons.check_circle_outline_rounded, const Color(0xFF10B981)),
              ]),

            const SizedBox(height: 28),

            // ── Responder por correo ─────────────────────────────────────────
            const Text('Responder al solicitante',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.fieldText)),
            const SizedBox(height: 6),

            // Correo destino
            Row(children: [
              const Icon(Icons.send_to_mobile_outlined,
                  size: 14, color: AppColors.fieldLabel),
              const SizedBox(width: 6),
              Text(
                'Se enviará a: ${s.correo}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.fieldLabel),
              ),
            ]),

            const SizedBox(height: 10),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _msgCtrl,
                    maxLines:   6,
                    minLines:   4,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText:    'Escribe aquí tu respuesta para ${s.nombre}...',
                      hintStyle:   const TextStyle(color: Colors.black38, fontSize: 13),
                      border:      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:   const BorderSide(color: AppColors.fieldBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                      filled:      true,
                      fillColor:   const Color(0xFFFDF5FF),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _enviandoMail ? null : _responder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: _enviandoMail
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.send_rounded, size: 18),
                      label: Text(
                        _enviandoMail ? 'Enviando...' : 'Enviar respuesta por correo',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Helpers de UI ───────────────────────────────────────────────────────────
  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.fieldBorder, width: 0.5),
          boxShadow: [
            BoxShadow(
              blurRadius: 12, offset: const Offset(0, 4),
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
                color: color, fontWeight: FontWeight.w700,
                fontSize: 10, letterSpacing: 0.5)),
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

  Widget _div() => const Divider(height: 1, color: Color(0xFFFFF0F6));

  Widget _btnEstado(String estado, String label, IconData icon, Color color) {
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
            Icon(icon, color: activo ? Colors.white : color, size: 22),
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