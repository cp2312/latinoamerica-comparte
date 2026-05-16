import 'package:flutter/material.dart';
import 'package:mobile/services/solicitudes_service.dart';

/// Formulario público de contacto — RF-07 / HU-19.
/// No requiere autenticación.
/// Envía directamente a POST /solicitudes/public en el backend.
/// [paisInicial] pre-selecciona el país cuando se abre desde
/// un portal de país específico (Colombia, Chile, Ecuador, Argentina).
class HomeContactCard extends StatefulWidget {
  final String paisInicial;

  const HomeContactCard({
    super.key,
    this.paisInicial = 'Colombia',
  });

  @override
  State<HomeContactCard> createState() => _HomeContactCardState();
}

class _HomeContactCardState extends State<HomeContactCard> {
  final _formKey   = GlobalKey<FormState>();
  final _nombre    = TextEditingController();
  final _correo    = TextEditingController();
  final _telefono  = TextEditingController();
  final _finalidad = TextEditingController();

  late String _paisSeleccionado;
  bool        _enviando = false;
  bool        _enviado  = false;
  String?     _errorMsg;

  static const _paises = ['Colombia', 'Chile', 'Ecuador', 'Argentina'];

  @override
  void initState() {
    super.initState();
    _paisSeleccionado = widget.paisInicial;
  }

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _telefono.dispose();
    _finalidad.dispose();
    super.dispose();
  }

  // ── Envío real al backend ─────────────────────────────────────────────────

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _enviando = true;
      _errorMsg = null;
    });

    final ok = await SolicitudesService().enviarSolicitudPublica(
      nombre:    _nombre.text.trim(),
      correo:    _correo.text.trim(),
      telefono:  _telefono.text.trim(),
      finalidad: _finalidad.text.trim(),
      pais:      _paisSeleccionado,
    );

    if (!mounted) return;

    if (ok) {
      setState(() {
        _enviando = false;
        _enviado  = true;
      });
    } else {
      setState(() {
        _enviando = false;
        _errorMsg = 'No se pudo enviar la solicitud. Intenta de nuevo.';
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_enviado) return _buildConfirmacion();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset:     const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Quieres saber más sobre nuestros programas?',
              style: TextStyle(
                fontSize:   15,
                fontWeight: FontWeight.bold,
                color:      Color(0xFF2E2E2E),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Déjanos tus datos y te contactamos.',
              style: TextStyle(fontSize: 13, color: Colors.black45),
            ),

            const SizedBox(height: 20),

            _Campo(
              controller: _nombre,
              label:      'Nombre completo',
              icono:      Icons.person_outline,
              validator:  (v) => v!.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 14),

            _Campo(
              controller: _correo,
              label:      'Correo electrónico',
              icono:      Icons.mail_outline,
              teclado:    TextInputType.emailAddress,
              validator:  (v) {
                if (v!.isEmpty) return 'Campo requerido';
                if (!v.contains('@')) return 'Correo inválido';
                return null;
              },
            ),
            const SizedBox(height: 14),

            _Campo(
              controller: _telefono,
              label:      'Teléfono',
              icono:      Icons.phone_outlined,
              teclado:    TextInputType.phone,
              validator:  (v) => v!.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 14),

            _Campo(
              controller: _finalidad,
              label:      '¿En qué podemos ayudarte?',
              icono:      Icons.help_outline,
              maxLines:   3,
              validator:  (v) => v!.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 14),

            // ── Selector de país ───────────────────────────────────────
            DropdownButtonFormField<String>(
              value: _paisSeleccionado,
              decoration: InputDecoration(
                labelText:  'País',
                prefixIcon: const Icon(Icons.public_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14,
                ),
              ),
              items: _paises
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _paisSeleccionado = v!),
            ),

            // ── Error ──────────────────────────────────────────────────
            if (_errorMsg != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color:        Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMsg!,
                        style: const TextStyle(
                            color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 22),

            SizedBox(
              width:  double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _enviando ? null : _enviar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0080),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _enviando
                    ? const SizedBox(
                        width:  22,
                        height: 22,
                        child:  CircularProgressIndicator(
                          color:       Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Enviar solicitud',
                        style: TextStyle(
                          fontSize:   15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmacion() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF6A0080),
            size:  56,
          ),
          const SizedBox(height: 16),
          const Text(
            '¡Solicitud enviada!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Nos pondremos en contacto contigo pronto '
            'desde el equipo de $_paisSeleccionado.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => setState(() {
              _enviado = false;
              _nombre.clear();
              _correo.clear();
              _telefono.clear();
              _finalidad.clear();
            }),
            child: const Text('Enviar otra solicitud'),
          ),
        ],
      ),
    );
  }
}

// ── Campo reutilizable ────────────────────────────────────────────────────────

class _Campo extends StatelessWidget {
  final TextEditingController      controller;
  final String                     label;
  final IconData                   icono;
  final TextInputType              teclado;
  final int                        maxLines;
  final String? Function(String?)? validator;

  const _Campo({
    required this.controller,
    required this.label,
    required this.icono,
    this.teclado   = TextInputType.text,
    this.maxLines  = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:   controller,
      keyboardType: teclado,
      maxLines:     maxLines,
      validator:    validator,
      decoration: InputDecoration(
        labelText:  label,
        prefixIcon: Icon(icono),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical:   14,
        ),
      ),
    );
  }
}