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

  Future<int> getCartCount(String token) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.cartCount),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['total_items'] ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<Map<String, dynamic>?> fetchProductDetails(int idObject) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.catalogDetails),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_object': idObject}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

}