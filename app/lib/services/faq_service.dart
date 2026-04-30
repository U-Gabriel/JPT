import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';

class FaqService {
  // Récupère tous les tags disponibles
  Future<List<dynamic>> fetchTags() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.tagsEndpoint));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded['data'] ?? [];
      }
    } catch (e) {
      print("Erreur fetchTags: $e");
    }
    return [];
  }

  // Recherche les FAQs par tag et/ou texte
  Future<List<dynamic>> searchFaqs({int? idTag, String? titleSearch}) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.faqByTagEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          if (idTag != null) "id_tag": idTag,
          if (titleSearch != null && titleSearch.isNotEmpty) "title_search": titleSearch,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded['data'] ?? [];
      }
    } catch (e) {
      print("Erreur searchFaqs: $e");
    }
    return [];
  }
}