import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/screens/models/news_model.dart';
import 'package:mobile/constants/api_constants.dart';

class NewsService {
  // BASE GENERAL DEL BACKEND
  static const String baseUrl = ApiConstants.baseUrl;

  // ─────────────────────────────────────────────
  // GET → TODAS LAS NOTICIAS (ADMIN)
  // GET → FILTRADAS POR PAÍS
  // ─────────────────────────────────────────────
  Future<List<NewsModel>> getNews({String? country}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token');

      String url = '$baseUrl/news';

      // filtro por país
      if (country != null && country.isNotEmpty) {
        final encodedCountry = Uri.encodeQueryComponent(country);

        url += '?pais=$encodedCountry';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data.map((item) {
          return NewsModel.fromJson(item);
        }).toList();
      }

      throw Exception('Error al cargar noticias (${response.statusCode})');
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  // GET → NOTICIAS PÚBLICAS
  // ─────────────────────────────────────────────
  Future<List<NewsModel>> getPublicNews() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/news?estado=publicado'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data.map((item) {
          return NewsModel.fromJson(item);
        }).toList();
      }

      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  // ─────────────────────────────────────────────
  // GET → NOTICIAS PÚBLICAS POR PAÍS
  // ─────────────────────────────────────────────
  Future<List<NewsModel>> getPublicNewsByCountry(String pais) async {
    try {
      final encodedPais = Uri.encodeQueryComponent(pais);

      final response = await http.get(
        Uri.parse('$baseUrl/news?estado=publicado&pais=$encodedPais'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data.map((item) {
          return NewsModel.fromJson(item);
        }).toList();
      }

      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  // ─────────────────────────────────────────────
  // POST → CREAR NOTICIA
  // ─────────────────────────────────────────────
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

      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/news'));

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['titulo'] = title;
      request.fields['pais'] = country;
      request.fields['contenido'] = content;
      request.fields['estado'] = status;

      // imagen
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

  // ─────────────────────────────────────────────
  // PUT → ACTUALIZAR NOTICIA
  // ─────────────────────────────────────────────
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

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/news/$id'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['titulo'] = title;
      request.fields['pais'] = country;
      request.fields['contenido'] = content;
      request.fields['estado'] = status;

      // imagen opcional
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

  // ─────────────────────────────────────────────
  // DELETE → ELIMINAR NOTICIA
  // ─────────────────────────────────────────────
  Future<bool> deleteNews(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('$baseUrl/news/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
