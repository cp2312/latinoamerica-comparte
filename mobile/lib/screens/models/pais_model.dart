class PaisModel {
  final String id;
  final String nombre;
  final String estado; // 'activo' | 'inactivo'
  final String? createdAt;
 
  const PaisModel({
    required this.id,
    required this.nombre,
    required this.estado,
    this.createdAt,
  });
 
  factory PaisModel.fromJson(Map<String, dynamic> json) {
    return PaisModel(
      id:        json['_id']       ?? '',
      nombre:    json['nombre']    ?? '',
      estado:    json['estado']    ?? 'activo',
      createdAt: json['createdAt'],
    );
  }
 
  // ── Helpers ────────────────────────────────────────────────────────────────
 
  bool get estaActivo => estado == 'activo';
 
  String get bandera {
    switch (nombre.toLowerCase()) {
      case 'colombia':  return '🇨🇴';
      case 'chile':     return '🇨🇱';
      case 'ecuador':   return '🇪🇨';
      case 'argentina': return '🇦🇷';
      default:          return '🌎';
    }
  }
}
