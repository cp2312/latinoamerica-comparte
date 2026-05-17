// lib/screens/widgets/solicitudes/solicitudes_screen.dart
//
// Funciona para superadmin (sin filtroPais → ve todos los países)
// y para admin_pais (filtroPais fijado → solo ve su país).

import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/services/solicitudes_service.dart';
import 'solicitud_detalle_screen.dart';

class SolicitudesScreen extends StatefulWidget {
  /// null → superadmin ve todos los países.
  /// no-null → admin_pais fija el país y no puede cambiarlo.
  final String? filtroPais;

  const SolicitudesScreen({super.key, this.filtroPais});

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  final _service = SolicitudesService();

  List<SolicitudModel> _items    = [];
  bool                 _cargando = true;
  bool                 _error    = false;
  String               _filtro   = ''; // '' = todos los estados

  // Pais fijado (admin_pais) o null (superadmin puede filtrar)
  String? get _paisFijo => widget.filtroPais;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() { _cargando = true; _error = false; });
    final data = await _service.getSolicitudes(
      pais:   _paisFijo,                              // fija si es admin_pais
      estado: _filtro.isEmpty ? null : _filtro,
    );
    if (!mounted) return;
    setState(() { _items = data; _cargando = false; });
  }

  Color    _colorEstado(String e) => switch (e) {
    'pendiente'  => const Color(0xFFF59E0B),
    'gestionada' => const Color(0xFF3B82F6),
    'respondida' => const Color(0xFF10B981),
    _            => Colors.grey,
  };

  IconData _iconEstado(String e) => switch (e) {
    'pendiente'  => Icons.hourglass_empty_rounded,
    'gestionada' => Icons.pending_actions_rounded,
    'respondida' => Icons.check_circle_outline_rounded,
    _            => Icons.circle_outlined,
  };

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final titulo = _paisFijo != null
        ? 'Solicitudes · $_paisFijo'
        : 'Solicitudes de Contacto';

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F8),
      appBar: AppBar(
        backgroundColor: AppColors.heroBottom,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(titulo,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _cargar,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFiltros(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  // ── Filtros de estado ──────────────────────────────────────────────────────

  Widget _buildFiltros() {
    const chips = [
      ('',           'Todas'),
      ('pendiente',  'Pendiente'),
      ('gestionada', 'Gestionada'),
      ('respondida', 'Respondida'),
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        const Text('Estado:',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.fieldText,
                fontSize: 12)),
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
                    selectedColor:   AppColors.primary,
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

  // ── Cuerpo ─────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    if (_cargando) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error) {
      return _vacio(
        icon: Icons.wifi_off_rounded,
        mensaje: 'No se pudo conectar con el servidor',
        boton: true,
      );
    }
    if (_items.isEmpty) {
      return _vacio(
        icon: Icons.inbox_rounded,
        mensaje: 'No hay solicitudes'
            '${_filtro.isNotEmpty ? ' con estado "$_filtro"' : ''}',
      );
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _cargar,
      child: ListView.builder(
        padding:     const EdgeInsets.all(16),
        itemCount:   _items.length,
        itemBuilder: (_, i) => _buildCard(_items[i]),
      ),
    );
  }

  Widget _vacio({
    required IconData icon,
    required String   mensaje,
    bool boton = false,
  }) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 60, color: AppColors.fieldBorder),
        const SizedBox(height: 12),
        Text(mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.fieldLabel, fontSize: 14)),
        if (boton) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _cargar,
            icon:  const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ]),
    );
  }

  // ── Card individual ────────────────────────────────────────────────────────

  Widget _buildCard(SolicitudModel s) {
    final color = _colorEstado(s.estado);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color:        Colors.white,
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
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => SolicitudDetalleScreen(solicitud: s)),
          );
          _cargar();
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            // Ícono de estado
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color:        color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_iconEstado(s.estado), color: color, size: 22),
            ),
            const SizedBox(width: 12),
            // Datos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.nombre,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize:   14,
                          color:      AppColors.fieldText)),
                  const SizedBox(height: 2),
                  Text(s.correo,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.fieldLabel)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Text('${s.bandera}  ${s.pais}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.primary)),
                    if (s.fechaFormateada.isNotEmpty) ...[
                      const Text('  ·  ',
                          style: TextStyle(color: AppColors.fieldBorder)),
                      Text(s.fechaFormateada,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.fieldLabel)),
                    ],
                  ]),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Badge estado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:        color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(s.estado.toUpperCase(),
                  style: TextStyle(
                      color:         color,
                      fontSize:      9,
                      fontWeight:    FontWeight.w700,
                      letterSpacing: 0.5)),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.fieldBorder, size: 20),
          ]),
        ),
      ),
    );
  }
}