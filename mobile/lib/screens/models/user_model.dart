// lib/screens/models/user_model.dart
//
// Modelo que representa al usuario autenticado.
// Parsea la respuesta del backend: { nombre, correo, rol, pais }
// donde pais es un String (ej: "Colombia") según el modelo User.js actual.

class UserModel {
  final String nombre;
  final String correo;
  final String rol; // "superadmin" | "admin_pais" | "editor"
  final String? pais; // "Colombia" | "Chile" | "Ecuador" | null

  const UserModel({
    required this.nombre,
    required this.correo,
    required this.rol,
    this.pais,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
      rol: json['rol'] ?? 'editor',
      pais: json['pais'], // puede ser null para superadmin
    );
  }

  // ── Helpers de rol ──────────────────────────────────────────────────────────

  bool get esSuperAdmin => rol == 'superadmin';
  bool get esAdminPais  => rol == 'admin_pais';
  bool get esEditor     => rol == 'editor';

  // ── Bandera según país ──────────────────────────────────────────────────────

  String get bandera {
    switch (pais?.toLowerCase()) {
      case 'colombia': return '🇨🇴';
      case 'chile':    return '🇨🇱';
      case 'ecuador':   return '🇪🇨';
      case 'argentina': return '🇦🇷';
      default:          return '🌎';
    }
  }

  String get paisDisplay => pais ?? 'Global';

  @override
  String toString() =>
      'UserModel(nombre: $nombre, rol: $rol, pais: $pais)';

    String get rolDisplay {
  switch (rol) {
    case 'superadmin': return 'Superadmin';
    case 'admin_pais': return 'Admin País';
    case 'editor':     return 'Editor';
    default:           return rol;
  }
}
}

