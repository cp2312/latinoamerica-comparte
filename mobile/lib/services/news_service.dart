import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
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
    PlatformFile? imageFile,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(baseUrl),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['titulo']    = title;
      request.fields['pais']      = country;
      request.fields['contenido'] = content;
      request.fields['estado']    = status;

      if (imageFile != null && imageFile.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'imagen',
            imageFile.bytes!,
            filename: imageFile.name,
          ),
        );
      }

      final response = await request.send();
      return response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
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
    PlatformFile? imageFile,
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

      if (imageFile != null && imageFile.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'imagen',
            imageFile.bytes!,
            filename: imageFile.name,
          ),
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