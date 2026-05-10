import 'package:flutter/material.dart';
import '../../services/news_service.dart';
import 'package:mobile/screens/models/news_model.dart';
import 'package:mobile/screens/widgets/news/news_card.dart';
import 'package:mobile/screens/widgets/news/create_news_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias'),
        centerTitle: true,
      ),

      // AQUÍ VA EL BOTÓN +
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateNewsScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: FutureBuilder<List<NewsModel>>(
        future: NewsService().getNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final newsList = snapshot.data ?? [];

          if (newsList.isEmpty) {
            return const Center(
              child: Text('No hay noticias disponibles'),
            );
          }

          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              return NewsCard(
                news: newsList[index],
              );
            },
          );
        },
      ),
    );
  }
}