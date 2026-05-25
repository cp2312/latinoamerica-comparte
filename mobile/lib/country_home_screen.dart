import 'package:flutter/material.dart';
import 'package:mobile/login_screen.dart';
import 'package:mobile/services/news_service.dart';
import 'package:mobile/services/testimonios_service.dart';
import 'package:mobile/screens/models/news_model.dart';
import 'package:mobile/screens/models/testimonio_model.dart';
import 'package:mobile/screens/widgets/home/home_news_card.dart';
import 'package:mobile/screens/widgets/home/home_section_title.dart';
import 'package:mobile/screens/widgets/home/home_testimonial_card.dart';
import 'package:mobile/screens/widgets/home/home_contact_card.dart';

// ── Configuración visual por país ─────────────────────────────────────────────

class _PaisConfig {
  final String nombre;
  final String codigo;
  final String bandera;
  final List<Color> gradiente;
  final Color appBarColor;
  final Color accentColor;
  final String tagline;
  final String subtitulo;
  final String programaDestacado;
  final String descripcionPrograma;
  final IconData iconaPrograma;

  const _PaisConfig({
    required this.nombre,
    required this.codigo,
    required this.bandera,
    required this.gradiente,
    required this.appBarColor,
    required this.accentColor,
    required this.tagline,
    required this.subtitulo,
    required this.programaDestacado,
    required this.descripcionPrograma,
    required this.iconaPrograma,
  });
}

final _configs = <String, _PaisConfig>{
  // ── COLOMBIA ──────────────────────────────────────────────────────────────
  'colombia': _PaisConfig(
    nombre: 'Colombia',
    codigo: 'CO',
    bandera: '🇨🇴',
    gradiente: const [
      Color(0xFFFCD116), // amarillo bandera
      Color(0xFFCE1126), // rojo bandera
      Color(0xFF003893), // azul bandera
    ],
    appBarColor: const Color(0xFF003893),
    accentColor: const Color(0xFFCE1126),
    tagline: 'Transformando vidas en Colombia',
    subtitulo:
        'Acompañamos a familias y emprendedores colombianos para recuperar sus fuentes de ingreso con dignidad y propósito.',
    programaDestacado: 'Programa Edifica Colombia',
    descripcionPrograma:
        'Impulsamos el emprendimiento personal en ciudades como Bogotá, Medellín y Cali.',
    iconaPrograma: Icons.storefront_outlined,
  ),

  // ── CHILE ─────────────────────────────────────────────────────────────────
  'chile': _PaisConfig(
    nombre: 'Chile',
    codigo: 'CL',
    bandera: '🇨🇱',
    gradiente: const [
      Color(0xFFD52B1E), // rojo bandera
      Color(0xFFB71C1C),
      Color(0xFF1A237E), // azul bandera
    ],
    appBarColor: const Color(0xFF1A237E),
    accentColor: const Color(0xFFD52B1E),
    tagline: 'Construyendo el Chile que queremos',
    subtitulo:
        'Apoyamos a emprendedores y líderes empresariales chilenos en su camino hacia la prosperidad sostenible.',
    programaDestacado: 'Programa Nodus Chile',
    descripcionPrograma:
        'Formamos líderes empresariales en Santiago, Valparaíso y Concepción con herramientas de gestión real.',
    iconaPrograma: Icons.leaderboard_outlined,
  ),

  // ── ARGENTINA ────────────────────────────────────────────────────────────
  'argentina': _PaisConfig(
    nombre: 'Argentina',
    codigo: 'AR',
    bandera: '🇦🇷',
    gradiente: const [
      Color(0xFF74ACDF), // celeste bandera
      Color(0xFF5B9DC9),
      Color(0xFFFFFFFF), // blanco bandera
    ],
    appBarColor: const Color(0xFF4A8DB5),
    accentColor: const Color(0xFF74ACDF),
    tagline: 'Emprendimiento con raíces argentinas',
    subtitulo:
        'Acompañamos a emprendedores y familias argentinas para reconstruir sus fuentes de ingreso con herramientas reales.',
    programaDestacado: 'Programa Edifica Argentina',
    descripcionPrograma:
        'Impulsamos emprendedores en Buenos Aires, Córdoba y Rosario con mentoría y planes de negocio personalizados.',
    iconaPrograma: Icons.emoji_people_outlined,
  ),

  // ── ECUADOR ───────────────────────────────────────────────────────────────
  'ecuador': _PaisConfig(
    nombre: 'Ecuador',
    codigo: 'EC',
    bandera: '🇪🇨',
    gradiente: const [
      Color(0xFFFFD100), // amarillo bandera
      Color(0xFF0033A0), // azul bandera
      Color(0xFFEF3340), // rojo bandera
    ],
    appBarColor: const Color(0xFF0033A0),
    accentColor: const Color(0xFFEF3340),
    tagline: 'Sembrando futuro en Ecuador',
    subtitulo:
        'Apoyamos a familias ecuatorianas en la construcción de emprendimientos sostenibles y con propósito.',
    programaDestacado: 'Programa Edifica Ecuador',
    descripcionPrograma:
        'Desarrollamos emprendedores en Quito, Guayaquil y Cuenca con acompañamiento personalizado.',
    iconaPrograma: Icons.eco_outlined,
  ),
};

// ── Pantalla principal por país ───────────────────────────────────────────────

class CountryHomeScreen extends StatelessWidget {
  /// Recibe el nombre del país en minúsculas: 'colombia', 'chile', 'ecuador', 'argentina'
  final String pais;

  const CountryHomeScreen({super.key, required this.pais});

  @override
  Widget build(BuildContext context) {
    final config = _configs[pais.toLowerCase()];

    // Fallback por si llega un país no configurado
    if (config == null) {
      return Scaffold(
        appBar: AppBar(title: Text(pais)),
        body: Center(child: Text('País no encontrado: $pais')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),

      // ── AppBar con color del país ──────────────────────────────────────
      appBar: AppBar(
        backgroundColor: config.appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(config.bandera, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Latinoamérica Comparte ${config.nombre}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              icon:
                  const Icon(Icons.lock_outline, color: Colors.white, size: 18),
              label: const Text(
                'Ingresar',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              ),
            ),
          ),
        ],
      ),

      // ── Cuerpo ────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero con gradiente del país
            _CountryHero(config: config),

            const SizedBox(height: 20),

            // Programa destacado del país
            _ProgramaCard(config: config),

            const SizedBox(height: 24),

            // Noticias filtradas por este país
            HomeSectionTitle(
              titulo: 'Noticias en ${config.nombre}',
              icono: Icons.article_outlined,
            ),
            const SizedBox(height: 12),
            _CountryNewsSection(pais: config.nombre),

            const SizedBox(height: 24),

            // ── Testimonios desde la API filtrados por país ───────────────
            HomeSectionTitle(
              titulo: 'Historias de éxito',
              icono: Icons.format_quote_rounded,
            ),
            const SizedBox(height: 12),
            _CountryTestimonialsSection(pais: config.nombre),

            const SizedBox(height: 24),

            // Contacto (pre-seleccionado el país)
            HomeSectionTitle(
              titulo: 'Contáctanos en ${config.nombre}',
              icono: Icons.mail_outline,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HomeContactCard(paisInicial: config.nombre, paisFijo: true),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Hero del país ─────────────────────────────────────────────────────────────

class _CountryHero extends StatelessWidget {
  final _PaisConfig config;
  const _CountryHero({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: config.gradiente,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bandera grande + badge de país
          Row(
            children: [
              Text(config.bandera,
                  style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.4), width: 1),
                ),
                child: Text(
                  config.codigo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tagline
          Text(
            config.tagline,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),

          // Subtítulo
          Text(
            config.subtitulo,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontSize: 14,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 20),

          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side:
                  const BorderSide(color: Colors.white54, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 10),
            ),
            child: Text(
              'Conoce ${config.nombre}',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta de programa destacado ────────────────────────────────────────────

class _ProgramaCard extends StatelessWidget {
  final _PaisConfig config;
  const _ProgramaCard({required this.config});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: config.accentColor.withOpacity(0.2),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: config.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                config.iconaPrograma,
                color: config.accentColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.programaDestacado,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: config.accentColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    config.descripcionPrograma,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sección noticias filtradas por país ───────────────────────────────────────

class _CountryNewsSection extends StatelessWidget {
  final String pais;
  const _CountryNewsSection({required this.pais});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsModel>>(
      future: NewsService().getPublicNewsByCountry(pais),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: Color(0xFF6A0080)),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return _EmptyState(
              mensaje: 'No se pudieron cargar las noticias de $pais');
        }

        final noticias = snapshot.data!;
        if (noticias.isEmpty) {
          return _EmptyState(
              mensaje: 'No hay noticias publicadas en $pais aún');
        }

        return SizedBox(
          height: 380,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: noticias.length,
            itemBuilder: (context, index) {
              return HomeNewsCard(noticia: noticias[index]);
            },
          ),
        );
      },
    );
  }
}

// ── Sección testimonios del país — datos reales desde la API ──────────────────
//
// Se reemplaza el uso de testimonios hardcodeados en _PaisConfig por un
// FutureBuilder que llama a TestimoniosService().getTestimoniosPublicos(pais:)
// para traer solo los testimonios publicados del país actual.

class _CountryTestimonialsSection extends StatelessWidget {
  final String pais;
  const _CountryTestimonialsSection({required this.pais});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TestimonioModel>>(
      future: TestimoniosService().getTestimoniosPublicos(pais: pais.toLowerCase()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: Color(0xFF6A0080)),
            ),
          );
        }

        final testimonios = snapshot.data ?? [];
        if (testimonios.isEmpty) {
          return _EmptyState(
            mensaje: 'No hay testimonios publicados en $pais aún',
          );
        }

        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: testimonios.length,
            itemBuilder: (context, index) {
              final t = testimonios[index];
              return HomeTestimonialCard(
                nombre: t.nombre,
                pais: t.pais,
                texto: t.testimonio,
                fotoUrl: t.fotoUrl,
              );
            },
          ),
        );
      },
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String mensaje;
  const _EmptyState({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child:
          Text(mensaje, style: const TextStyle(color: Colors.black45, fontSize: 13)),
    );
  }
}