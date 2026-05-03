import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';

class ShoppingService {
  Future<List<dynamic>> fetchCatalog({int? idTag, String? titleSearch}) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.ShoppingPageEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          if (idTag != null) "id_tag": idTag,
          if (titleSearch != null && titleSearch.isNotEmpty) "title_search": titleSearch,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}