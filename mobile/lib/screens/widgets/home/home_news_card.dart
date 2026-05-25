import 'package:flutter/material.dart';
import 'package:mobile/screens/models/news_model.dart';

class HomeNewsCard extends StatelessWidget {
  final NewsModel noticia;

  const HomeNewsCard({
    super.key,
    required this.noticia,
  });

  String get _logoAsset {
    switch (noticia.country.toLowerCase()) {
      case 'colombia':
        return 'assets/images/logo_colombia.png';
      case 'chile':
        return 'assets/images/logo_chile.png';
      case 'ecuador':
        return 'assets/images/logo_ecuador.png';
      case 'argentina':
        return 'assets/images/logo_argentina.png';
      default:
        return 'assets/images/logo_latam.png';
    }
  }

  String get imageUrl {
    if (noticia.image.isEmpty) {
      return '';
    }

    return 'http://127.0.0.1:3000${noticia.image}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGEN
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                        ),
                      );
                    },
                  )
                : Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_outlined,
                      size: 40,
                    ),
                  ),
          ),

          /// CONTENIDO
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PAÍS + LOGO
                  Row(
                    children: [
                      Image.asset(
                        _logoAsset,
                        width: 22,
                        height: 22,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          noticia.country,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// TÍTULO
                  Text(
                    noticia.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E2E2E),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// CONTENIDO CON SCROLL
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      radius: const Radius.circular(10),
                      child: SingleChildScrollView(
                        child: Text(
                          noticia.content,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A0080).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'PUBLICADO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6A0080),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}