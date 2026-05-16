// lib/screens/models/testimonio_model.dart
// Espeja exactamente el esquema del backend: models/Testimonio.ts

class TestimonioModel {
  final String  id;
  final String  nombre;
  final String? fotoUrl;
  final String  testimonio;
  final String  pais;          // 'colombia' | 'chile' | 'ecuador'
  final String? instagramUrl;
  final String? facebookUrl;
  final String  estado;        // 'borrador' | 'publicado' | 'despublicado'
  final String? createdAt;

  const TestimonioModel({
    required this.id,
    required this.nombre,
    this.fotoUrl,
    required this.testimonio,
    required this.pais,
    this.instagramUrl,
    this.facebookUrl,
    required this.estado,
    this.createdAt,
  });

  factory TestimonioModel.fromJson(Map<String, dynamic> j) => TestimonioModel(
        id:           j['_id']?.toString()           ?? '',
        nombre:       j['nombre']?.toString()         ?? '',
        fotoUrl:      j['foto_url']?.toString(),
        testimonio:   j['testimonio']?.toString()     ?? '',
        pais:         j['pais']?.toString()           ?? '',
        instagramUrl: j['instagram_url']?.toString(),
        facebookUrl:  j['facebook_url']?.toString(),
        estado:       j['estado']?.toString()         ?? 'borrador',
        createdAt:    j['createdAt']?.toString(),
      );

  String get bandera {
    switch (pais.toLowerCase()) {
      case 'colombia': return '🇨🇴';
      case 'chile':    return '🇨🇱';
      case 'ecuador':  return '🇪🇨';
      default:         return '🌎';
    }
  }

  String get fechaFormateada {
    if (createdAt == null) return '';
    try { return createdAt!.substring(0, 10); } catch (_) { return ''; }
  }
}
