import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../models/cart_item.dart';
import 'api_client.dart';

class ShoppingService {
  final ApiClient _apiClient = ApiClient();

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

  Future<int> getCartCount() async {
    try {
      final response = await _apiClient.post(Uri.parse(AppConfig.cartCount));

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

  Future<bool> addToCart({required int idObject, required int quantity}) async {
    try {
      final response = await _apiClient.post(
        Uri.parse(AppConfig.cartAdd),
        body: jsonEncode({
          "id_object": idObject,
          "object_quantity": quantity,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['status'] == "OK";
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<CartItem>> fetchCartList() async {
    try {
      final response = await _apiClient.get(Uri.parse(AppConfig.cartList));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List list = data['data'] ?? [];
        return list.map((item) => CartItem.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteCartItem(int idCartItem) async {
    try {
      final response = await _apiClient.post(
        Uri.parse(AppConfig.cartDelete),
        body: jsonEncode({"id_cart_item": idCartItem}),
      );

      final data = jsonDecode(response.body);
      return data['status'] == "OK";
    } catch (e) {
      return false;
    }
  }

}