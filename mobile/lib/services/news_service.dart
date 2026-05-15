import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/screens/models/news_model.dart';

class NewsService {
  final String baseUrl = 'http://127.0.0.1:3000/news';

  // GET → listar noticias (autenticado)
  Future<List<NewsModel>> getNews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((item) => NewsModel.fromJson(item)).toList();
      }

      throw Exception('Error al obtener noticias');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // GET → noticias públicas (sin token) — todas las publicadas
  Future<List<NewsModel>> getPublicNews() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?estado=publicado'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((item) => NewsModel.fromJson(item)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // GET → noticias públicas filtradas por país
  // Usado en los homes de cada país (CountryHomeScreen).
  Future<List<NewsModel>> getPublicNewsByCountry(String pais) async {
    try {
      final encodedPais = Uri.encodeQueryComponent(pais);
      final response = await http.get(
        Uri.parse('$baseUrl?estado=publicado&pais=$encodedPais'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((item) => NewsModel.fromJson(item)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // POST → crear noticia
  Future<bool> createNews({
    required String title,
    required String country,
    required String content,
    required String status,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'titulo':    title,
          'pais':      country,
          'contenido': content,
          'estado':    status,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Error al crear noticia: $e');
    }
  }

  // DELETE → eliminar noticia
  Future<bool> deleteNews(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // PUT → actualizar noticia
  Future<bool> updateNews({
    required String id,
    required String title,
    required String country,
    required String content,
    required String status,
    String? imagePath,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/$id'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['titulo']    = title;
      request.fields['pais']      = country;
      request.fields['contenido'] = content;
      request.fields['estado']    = status;

      if (imagePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath('imagen', imagePath),
        );
      }

      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}