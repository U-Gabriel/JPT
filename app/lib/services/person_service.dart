import 'dart:convert';
import 'package:app/models/cart_item.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../models/address_person.dart';
import 'api_client.dart';

class PersonService {
  final ApiClient _apiClient = ApiClient();

  // 1. Recherche d'adresses (Suggestions)
  Future<List<dynamic>> searchAddressSuggestions(String query) async {
    if (query.length < 3) return [];

    final response = await http.get(
      Uri.parse("${AppConfig.geoApiGouv}?q=${Uri.encodeComponent(query)}&limit=5"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['features']; // Contient la liste des adresses formatées
    }
    return [];
  }

  // 2. Enregistrement de l'adresse dans ton Backend
  Future<bool> saveAddress(Map<String, dynamic> addressData) async {
    final response = await _apiClient.post(
      Uri.parse(AppConfig.addressEndpoint),
      body: json.encode(addressData),
    );

    return response.statusCode == 200;
  }

  Future<List<AddressPerson>> fetchAddresses() async {
    final response = await _apiClient.get(
      Uri.parse(AppConfig.addressListEndpoint),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => AddressPerson.fromJson(json)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>?> createPaymentIntent(List<CartItem> items, int addressId) async {
    final response = await _apiClient.post(
      Uri.parse(AppConfig.createPaymentIntentEndpoint),
      body: json.encode({
        'id_address_delivery': addressId,
        'items': items.map((e) => {
          'id_cart_item': e.idCartItem,
          'quantity': e.quantity
        }).toList(),
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    }
    return null;
  }
}