import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

/// Formulario público de contacto (RF-07 / HU-19).
/// No requiere autenticación.
/// [paisInicial] permite pre-seleccionar el país cuando se abre
/// desde un portal de país específico.
/// TODO Fase 4: conectar con POST /solicitudes (endpoint público sin JWT).
class HomeContactCard extends StatefulWidget {
  final String paisInicial;
  /// Si viene de un portal de país específico, el selector queda bloqueado.
  final bool   paisFijo;

  const HomeContactCard({
    super.key,
    this.paisInicial = 'Colombia',
    this.paisFijo    = false,
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

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enviando = true);

    // TODO Fase 4: llamar API pública
    // await SolicitudesService().enviarSolicitud(
    //   nombre:   _nombre.text,
    //   correo:   _correo.text,
    //   telefono: _telefono.text,
    //   finalidad: _finalidad.text,
    //   pais:     _paisSeleccionado,
    // );

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() {
      _enviando = false;
      _enviado  = true;
    });
  }

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
              controller:    _correo,
              label:         'Correo electrónico',
              icono:         Icons.mail_outline,
              teclado:       TextInputType.emailAddress,
              validator: (v) {
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

            // ── Selector de país ─────────────────────────────────────────
// Si paisFijo = true (venimos de un portal de país),
// mostramos el campo de solo lectura en lugar del dropdown.
widget.paisFijo
    ? _CampoPaisFijo(pais: _paisSeleccionado)
    : DropdownButtonFormField<String>(
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
        items: _paises.map((p) => DropdownMenuItem(
          value: p,
          child: Text(p),
        )).toList(),
        onChanged: (v) => setState(() => _paisSeleccionado = v!),
      ),

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
                        width: 22, height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Enviar solicitud',
                        style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600,
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
          const Icon(Icons.check_circle_outline,
              color: Color(0xFF6A0080), size: 56),
          const SizedBox(height: 16),
          const Text(
            '¡Solicitud enviada!',
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nos pondremos en contacto contigo pronto en $_paisSeleccionado.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => setState(() => _enviado = false),
            child: const Text('Enviar otra solicitud'),
          ),
        ],
      ),
    );
  }
}

// ── Campo de país fijo (solo lectura) ────────────────────────────────────────

class _CampoPaisFijo extends StatelessWidget {
  final String pais;
  const _CampoPaisFijo({required this.pais});

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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color:        const Color(0xFFF9F0FF),
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: const Color(0xFFCE93D8), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.public_outlined, color: Color(0xFF6A0080), size: 20),
          const SizedBox(width: 12),
          Text(
            '$_bandera  $pais',
            style: const TextStyle(
              fontSize:   14,
              fontWeight: FontWeight.w600,
              color:      Color(0xFF6A0080),
            ),
          ),
          const Spacer(),
          const Icon(Icons.lock_outline, size: 14, color: Colors.black26),
        ],
      ),
    );
  }
}

// ── Campo reutilizable ────────────────────────────────────────────────────────

class _Campo extends StatelessWidget {
  final TextEditingController        controller;
  final String                       label;
  final IconData                     icono;
  final TextInputType                teclado;
  final int                          maxLines;
  final String? Function(String?)?   validator;

  const _Campo({
    required this.controller,
    required this.label,
    required this.icono,
    this.teclado  = TextInputType.text,
    this.maxLines = 1,
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
          horizontal: 14, vertical: 14,
        ),
      ),
    );
  }
}