// lib/screens/widgets/testimonios/testimonio_form_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/services/testimonios_service.dart';
import 'package:mobile/screens/models/testimonio_model.dart';

class TestimonioFormScreen extends StatefulWidget {
  /// null → crear nuevo | no-null → editar existente
  final TestimonioModel? testimonioExistente;

  const TestimonioFormScreen({super.key, this.testimonioExistente});

  @override
  State<TestimonioFormScreen> createState() => _TestimonioFormScreenState();
}

class _TestimonioFormScreenState extends State<TestimonioFormScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _service  = TestimoniosService();

  final _nombreCtrl     = TextEditingController();
  final _fotoCtrl       = TextEditingController();
  final _testimonioCtrl = TextEditingController();
  final _instCtrl       = TextEditingController();
  final _fbCtrl         = TextEditingController();

  String _pais   = 'colombia';
  String _estado = 'borrador';
  bool   _guardando = false;

  bool get _esEdicion => widget.testimonioExistente != null;

  // Países igual que el backend los guarda: en minúscula
  static const _paises = [
    ('colombia', '🇨🇴  Colombia'),
    ('chile',    '🇨🇱  Chile'),
    ('ecuador',  '🇪🇨  Ecuador'),
  ];

  @override
  void initState() {
    super.initState();
    final t = widget.testimonioExistente;
    if (t == null) return;
    _nombreCtrl.text     = t.nombre;
    _fotoCtrl.text       = t.fotoUrl      ?? '';
    _testimonioCtrl.text = t.testimonio;
    _instCtrl.text       = t.instagramUrl ?? '';
    _fbCtrl.text         = t.facebookUrl  ?? '';
    _pais                = t.pais.toLowerCase();
    _estado              = t.estado;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _fotoCtrl.dispose();
    _testimonioCtrl.dispose();
    _instCtrl.dispose();
    _fbCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final bool ok;
    if (_esEdicion) {
      ok = await _service.actualizarTestimonio(
        id:           widget.testimonioExistente!.id,
        nombre:       _nombreCtrl.text.trim(),
        testimonio:   _testimonioCtrl.text.trim(),
        pais:         _pais,
        fotoUrl:      _fotoCtrl.text.trim().isEmpty ? null : _fotoCtrl.text.trim(),
        instagramUrl: _instCtrl.text.trim().isEmpty ? null : _instCtrl.text.trim(),
        facebookUrl:  _fbCtrl.text.trim().isEmpty  ? null : _fbCtrl.text.trim(),
        estado:       _estado,
      );
    } else {
      ok = await _service.crearTestimonio(
        nombre:       _nombreCtrl.text.trim(),
        testimonio:   _testimonioCtrl.text.trim(),
        pais:         _pais,
        fotoUrl:      _fotoCtrl.text.trim().isEmpty ? null : _fotoCtrl.text.trim(),
        instagramUrl: _instCtrl.text.trim().isEmpty ? null : _instCtrl.text.trim(),
        facebookUrl:  _fbCtrl.text.trim().isEmpty  ? null : _fbCtrl.text.trim(),
        estado:       _estado,
      );
    }

    if (!mounted) return;
    setState(() => _guardando = false);

    if (ok) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_esEdicion
            ? 'Testimonio actualizado correctamente'
            : 'Testimonio creado correctamente'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se pudo guardar. Verifica los datos e intenta de nuevo.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F8),
      appBar: AppBar(
        backgroundColor: AppColors.heroBottom,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _esEdicion ? 'Editar Testimonio' : 'Nuevo Testimonio',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Info básica ───────────────────────────────────────────────
              _seccion('Información básica'),
              const SizedBox(height: 10),
              _tarjeta(Column(children: [
                _campo(
                  ctrl: _nombreCtrl,
                  label: 'Nombre completo *',
                  icon: Icons.person_outline_rounded,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 14),
                _campo(
                  ctrl: _fotoCtrl,
                  label: 'URL de la foto',
                  icon: Icons.image_outlined,
                  hint: 'https://ejemplo.com/foto.jpg',
                  onChanged: (_) => setState(() {}),
                ),
                // Preview de la foto
                if (_fotoCtrl.text.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _fotoCtrl.text.trim(),
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.fieldBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('URL de imagen no válida',
                              style: TextStyle(
                                  color: AppColors.fieldLabel,
                                  fontSize: 12)),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                _campo(
                  ctrl: _testimonioCtrl,
                  label: 'Testimonio *',
                  icon: Icons.format_quote_rounded,
                  maxLines: 5,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'El testimonio es requerido'
                      : null,
                ),
              ])),

              const SizedBox(height: 16),

              // ── Configuración ─────────────────────────────────────────────
              _seccion('Configuración'),
              const SizedBox(height: 10),
              _tarjeta(Column(children: [
                _dropdown<String>(
                  label: 'País *',
                  icon: Icons.location_on_outlined,
                  value: _pais,
                  items: _paises
                      .map((p) => DropdownMenuItem(
                          value: p.$1, child: Text(p.$2)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _pais = v ?? _pais),
                ),
                const SizedBox(height: 14),
                _dropdown<String>(
                  label: 'Estado de publicación',
                  icon: Icons.public_rounded,
                  value: _estado,
                  items: const [
                    DropdownMenuItem(
                        value: 'borrador',
                        child: Text('📝  Borrador')),
                    DropdownMenuItem(
                        value: 'publicado',
                        child: Text('✅  Publicado')),
                    DropdownMenuItem(
                        value: 'despublicado',
                        child: Text('🚫  Despublicado')),
                  ],
                  onChanged: (v) =>
                      setState(() => _estado = v ?? _estado),
                ),
              ])),

              const SizedBox(height: 16),

              // ── Redes sociales ────────────────────────────────────────────
              _seccion('Redes sociales (opcional)'),
              const SizedBox(height: 10),
              _tarjeta(Column(children: [
                _campo(
                  ctrl: _instCtrl,
                  label: 'Instagram URL',
                  icon: Icons.camera_alt_outlined,
                  hint: 'https://instagram.com/usuario',
                ),
                const SizedBox(height: 14),
                _campo(
                  ctrl: _fbCtrl,
                  label: 'Facebook URL',
                  icon: Icons.facebook_rounded,
                  hint: 'https://facebook.com/usuario',
                ),
              ])),

              const SizedBox(height: 24),

              // ── Botón guardar ─────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _guardando ? null : _guardar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _guardando
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Text(
                          _esEdicion
                              ? 'Guardar cambios'
                              : 'Crear testimonio',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── Widgets de apoyo ───────────────────────────────────────────────────────
  Widget _seccion(String t) => Row(children: [
        Text(t.toUpperCase(),
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: 1)),
        const SizedBox(width: 8),
        const Expanded(child: Divider(color: AppColors.fieldBorder)),
      ]);

  Widget _tarjeta(Widget child) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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

  Widget _campo({
    required TextEditingController ctrl,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) =>
      TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon:
              Icon(icon, size: 20, color: AppColors.fieldIcon),
          filled: true,
          fillColor: AppColors.fieldBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
                color: AppColors.fieldFocused, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red),
          ),
          labelStyle:
              const TextStyle(fontSize: 13, color: AppColors.fieldLabel),
        ),
      );

  Widget _dropdown<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) =>
      DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              Icon(icon, size: 20, color: AppColors.fieldIcon),
          filled: true,
          fillColor: AppColors.fieldBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
                color: AppColors.fieldFocused, width: 1.5),
          ),
          labelStyle:
              const TextStyle(fontSize: 13, color: AppColors.fieldLabel),
        ),
      );
}
