import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/screens/models/pais_model.dart';
import 'package:mobile/services/paises_services.dart';
import 'pais_card.dart';
 
/// Pantalla de gestión de países — exclusiva para el superadmin.
/// Permite:
///   • Ver el listado de países con su estado actual
///   • Activar / desactivar un país (modo mantenimiento) con un Switch
///   • Crear un nuevo país
///   • Editar el nombre de un país existente
///   • Eliminar un país
class PaisesScreen extends StatefulWidget {
  const PaisesScreen({super.key});
 
  @override
  State<PaisesScreen> createState() => _PaisesScreenState();
}
 
class _PaisesScreenState extends State<PaisesScreen> {
  final _service = PaisesService();
 
  List<PaisModel> _paises   = [];
  bool            _cargando = true;
 
  @override
  void initState() {
    super.initState();
    _cargar();
  }
 
  // ── Carga inicial ──────────────────────────────────────────────────────────
  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final data = await _service.getPaises();
    if (!mounted) return;
    setState(() { _paises = data; _cargando = false; });
  }
 
  // ── Toggle de estado (el switch de la tarjeta) ─────────────────────────────
  Future<void> _toggleEstado(PaisModel pais, bool activar) async {
    final nuevoEstado = activar ? 'activo' : 'inactivo';
    final ok = await _service.cambiarEstado(pais.id, nuevoEstado);
    if (!mounted) return;
 
    if (ok) {
      _cargar(); // refresca la lista desde el servidor
      _showSnack(
        activar
            ? '${pais.bandera} ${pais.nombre} activado'
            : '${pais.bandera} ${pais.nombre} en mantenimiento',
        activar ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
      );
    } else {
      _showSnack('No se pudo actualizar el estado', Colors.red);
    }
  }
 
  // ── Diálogo crear / editar ─────────────────────────────────────────────────
  Future<void> _abrirFormulario({PaisModel? editando}) async {
    final controller = TextEditingController(
      text: editando?.nombre ?? '',
    );
    final esEdicion = editando != null;
 
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          esEdicion ? 'Editar país' : 'Nuevo país',
          style: const TextStyle(
            color:      Color(0xFF4A0030),
            fontWeight: FontWeight.w700,
            fontSize:   17,
          ),
        ),
        content: TextField(
          controller:    controller,
          autofocus:     true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText:   'Nombre del país',
            labelStyle:  const TextStyle(color: AppColors.fieldLabel),
            prefixIcon:  const Icon(Icons.public_rounded,
                color: AppColors.fieldIcon),
            filled:      true,
            fillColor:   AppColors.fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.fieldFocused, width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final nombre = controller.text.trim();
              if (nombre.isEmpty) return;
 
              Navigator.pop(ctx);
              bool ok;
 
              if (esEdicion) {
                ok = await _service.editarPais(editando.id, nombre);
              } else {
                ok = await _service.crearPais(nombre);
              }
 
              if (!mounted) return;
              if (ok) {
                _cargar();
                _showSnack(
                  esEdicion ? 'País actualizado' : 'País creado',
                  const Color(0xFF10B981),
                );
              } else {
                _showSnack(
                  esEdicion
                      ? 'No se pudo actualizar. ¿Nombre duplicado?'
                      : 'No se pudo crear. ¿Ya existe?',
                  Colors.red,
                );
              }
            },
            child: Text(esEdicion ? 'Guardar' : 'Crear'),
          ),
        ],
      ),
    );
  }
 
  // ── Confirmación eliminar ──────────────────────────────────────────────────
  Future<void> _confirmarEliminar(PaisModel pais) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Eliminar ${pais.nombre}',
            style: const TextStyle(
                color: Color(0xFF4A0030), fontWeight: FontWeight.w700)),
        content: Text(
          'Se eliminará el país permanentemente. '
          'Esta acción no afecta noticias ni testimonios existentes, '
          'pero no podrás volver a usarlo.',
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
 
    if (confirmar != true || !mounted) return;
 
    final ok = await _service.eliminarPais(pais.id);
    if (!mounted) return;
 
    if (ok) {
      _cargar();
      _showSnack('${pais.nombre} eliminado', const Color(0xFF10B981));
    } else {
      _showSnack('No se pudo eliminar', Colors.red);
    }
  }
 
  // ── Helpers de UI ──────────────────────────────────────────────────────────
  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:         Text(msg),
        backgroundColor: color,
        behavior:        SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
 
  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F8),
      appBar: AppBar(
        backgroundColor: AppColors.heroBottom,
        foregroundColor: Colors.white,
        elevation:       0,
        title: const Text(
          'Gestión de Países',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon:      const Icon(Icons.refresh_rounded),
            onPressed: _cargar,
            tooltip:   'Recargar',
          ),
        ],
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _paises.isEmpty
              ? _buildVacio()
              : _buildLista(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:       () => _abrirFormulario(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon:            const Icon(Icons.add_rounded),
        label:           const Text('Nuevo país'),
      ),
    );
  }
 
  // ── Lista de países ────────────────────────────────────────────────────────
  Widget _buildLista() {
    // Separar activos e inactivos para mostrarlos en secciones
    final activos   = _paises.where((p) => p.estaActivo).toList();
    final inactivos = _paises.where((p) => !p.estaActivo).toList();
 
    return RefreshIndicator(
      color:      AppColors.primary,
      onRefresh:  _cargar,
      child: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 100),
        children: [
          // ── Banner informativo ─────────────────────────────────────────────
          _buildBanner(),
 
          // ── Sección activos ────────────────────────────────────────────────
          if (activos.isNotEmpty) ...[
            _buildSectionHeader(
              '${activos.length} país${activos.length > 1 ? 'es' : ''} activo${activos.length > 1 ? 's' : ''}',
              const Color(0xFF10B981),
              Icons.public_rounded,
            ),
            ...activos.map((p) => PaisCard(
                  pais:           p,
                  onToggleEstado: (v) => _toggleEstado(p, v),
                )),
          ],
 
          // ── Sección inactivos ──────────────────────────────────────────────
          if (inactivos.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildSectionHeader(
              '${inactivos.length} en mantenimiento',
              const Color(0xFFF59E0B),
              Icons.build_rounded,
            ),
            ...inactivos.map((p) => PaisCard(
                  pais:           p,
                  onToggleEstado: (v) => _toggleEstado(p, v),
                )),
          ],
        ],
      ),
    );
  }
 
  // ── Banner de información ──────────────────────────────────────────────────
  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF0F6), Color(0xFFFDF5F8)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF8BBD0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:        AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.info_outline_rounded,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Desactiva un país para ponerlo en modo mantenimiento. '
              'Los portales inactivos no mostrarán contenido a los usuarios.',
              style: TextStyle(
                  fontSize: 12, color: Color(0xFF6B2D5E), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
 
  // ── Encabezado de sección ──────────────────────────────────────────────────
  Widget _buildSectionHeader(String label, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize:      11,
              fontWeight:    FontWeight.w700,
              color:         color,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
 
  // ── Estado vacío ───────────────────────────────────────────────────────────
  Widget _buildVacio() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.public_off_rounded,
              size: 56, color: AppColors.primaryLight),
          const SizedBox(height: 16),
          const Text(
            'No hay países registrados',
            style: TextStyle(
                color: Color(0xFF4A0030), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Usa el botón + para agregar el primero.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
