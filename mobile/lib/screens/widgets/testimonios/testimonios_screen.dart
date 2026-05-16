// lib/screens/widgets/testimonios/testimonios_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/services/testimonios_service.dart';
import 'package:mobile/screens/models/testimonio_model.dart';
import 'testimonio_form_screen.dart';

class TestimoniosScreen extends StatefulWidget {
  const TestimoniosScreen({super.key});

  @override
  State<TestimoniosScreen> createState() => _TestimoniosScreenState();
}

class _TestimoniosScreenState extends State<TestimoniosScreen> {
  final _service = TestimoniosService();

  List<TestimonioModel> _items    = [];
  bool                  _cargando = true;
  String                _filtro   = '';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final data = await _service.getTestimonios(
      estado: _filtro.isEmpty ? null : _filtro,
    );
    if (!mounted) return;
    setState(() { _items = data; _cargando = false; });
  }

  Color _colorEstado(String e) => switch (e) {
        'publicado'    => const Color(0xFF10B981),
        'despublicado' => const Color(0xFFEF4444),
        _              => const Color(0xFF9CA3AF),
      };

  // ── Toggle publicado/despublicado ──────────────────────────────────────────
  Future<void> _toggleEstado(TestimonioModel t) async {
    final nuevo = t.estado == 'publicado' ? 'despublicado' : 'publicado';
    final ok    = await _service.cambiarEstado(t.id, nuevo);
    if (!mounted) return;
    if (ok) {
      _cargar();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se pudo cambiar el estado'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  // ── Eliminar ───────────────────────────────────────────────────────────────
  Future<void> _confirmarEliminar(TestimonioModel t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Eliminar testimonio',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text(
            '¿Confirmas que deseas eliminar el testimonio de "${t.nombre}"?'),
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
    final eliminado = await _service.eliminarTestimonio(t.id);
    if (!mounted) return;
    if (eliminado) {
      _cargar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Testimonio eliminado'),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se pudo eliminar el testimonio'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  // ── Navegar al formulario ──────────────────────────────────────────────────
  Future<void> _irFormulario({TestimonioModel? testimonio}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) =>
              TestimonioFormScreen(testimonioExistente: testimonio)),
    );
    _cargar();
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
        title: const Text('Testimonios de Éxito',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh_rounded), onPressed: _cargar),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _irFormulario(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Column(children: [
        _buildFiltros(),
        Expanded(child: _buildBody()),
      ]),
    );
  }

  // ── Filtros ────────────────────────────────────────────────────────────────
  Widget _buildFiltros() {
    const chips = [
      ('',             'Todos'),
      ('borrador',     'Borrador'),
      ('publicado',    'Publicado'),
      ('despublicado', 'Despublicado'),
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        const Text('Estado:',
            style: TextStyle(fontWeight: FontWeight.w600,
                color: AppColors.fieldText, fontSize: 12)),
        const SizedBox(width: 10),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chips.map((c) {
                final sel = _filtro == c.$1;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(c.$2,
                        style: TextStyle(
                            color: sel ? Colors.white : AppColors.fieldText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                    selected: sel,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.fieldBg,
                    onSelected: (_) {
                      setState(() => _filtro = c.$1);
                      _cargar();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ]),
    );
  }

  // ── Lista ──────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    if (_cargando) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_items.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.record_voice_over_outlined,
              size: 60, color: AppColors.fieldBorder),
          const SizedBox(height: 12),
          Text(
            'No hay testimonios'
            '${_filtro.isNotEmpty ? ' con estado "$_filtro"' : ''}',
            style: const TextStyle(
                color: AppColors.fieldLabel, fontSize: 14),
          ),
        ]),
      );
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _cargar,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        itemCount: _items.length,
        itemBuilder: (_, i) => _buildCard(_items[i]),
      ),
    );
  }

  // ── Card ───────────────────────────────────────────────────────────────────
  Widget _buildCard(TestimonioModel t) {
    final color = _colorEstado(t.estado);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Foto / Avatar ────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: (t.fotoUrl != null && t.fotoUrl!.isNotEmpty)
                ? Image.network(t.fotoUrl!,
                    width: 54, height: 54, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _avatar(t))
                : _avatar(t),
          ),
          const SizedBox(width: 12),

          // ── Info ─────────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.nombre,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.fieldText)),
                const SizedBox(height: 2),
                Text('${t.bandera}  ${t.pais}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.fieldLabel)),
                const SizedBox(height: 6),
                // Badge + botón toggle
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(t.estado.toUpperCase(),
                        style: TextStyle(
                            color: color,
                            fontSize: 9,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _toggleEstado(t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: t.estado == 'publicado'
                            ? const Color(0xFFFFF3E0)
                            : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: t.estado == 'publicado'
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF10B981),
                        ),
                      ),
                      child: Text(
                        t.estado == 'publicado'
                            ? '↓ Despublicar'
                            : '↑ Publicar',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: t.estado == 'publicado'
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),

          // ── Acciones ─────────────────────────────────────────────────────
          Column(children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  size: 20, color: AppColors.primary),
              onPressed: () => _irFormulario(testimonio: t),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(height: 10),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  size: 20, color: Color(0xFFEF4444)),
              onPressed: () => _confirmarEliminar(t),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _avatar(TestimonioModel t) => Container(
        width: 54, height: 54,
        decoration: BoxDecoration(
          color: AppColors.fieldBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            t.nombre.isNotEmpty ? t.nombre[0].toUpperCase() : '?',
            style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 22),
          ),
        ),
      );
}
