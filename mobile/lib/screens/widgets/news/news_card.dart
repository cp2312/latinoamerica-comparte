import 'package:flutter/material.dart';
import 'package:mobile/screens/models/news_model.dart';
import 'package:mobile/services/news_service.dart';
import 'create_news_screen.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;

  const NewsCard({
    super.key,
    required this.news,
  });

  Future<void> deleteNews(BuildContext context) async {
    final success = await NewsService().deleteNews(news.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Noticia eliminada correctamente'
              : 'Error al eliminar noticia',
        ),
      ),
    );
  }

  void editNews(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateNewsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),

        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0xFFF5F7FA),
          ),
          child: const Icon(
            Icons.article_outlined,
            size: 26,
          ),
        ),

        title: Text(
          news.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.country,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFFF2F6FF),
                ),
                child: Text(
                  news.status.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        trailing: SizedBox(
          width: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 22,
                ),
                onPressed: () => editNews(context),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 22,
                ),
                onPressed: () => deleteNews(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}