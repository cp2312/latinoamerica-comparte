import 'package:flutter/material.dart';

class HomeSectionTitle extends StatelessWidget {
  final String   titulo;
  final IconData icono;

  const HomeSectionTitle({
    super.key,
    required this.titulo,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:        const Color(0xFF6A0080).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: const Color(0xFF6A0080), size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: const TextStyle(
              fontSize:   18,
              fontWeight: FontWeight.bold,
              color:      Color(0xFF2E2E2E),
            ),
          ),
        ],
      ),
    );
  }
}