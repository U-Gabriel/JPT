import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/app_config.dart';

import 'api_client.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();
  Future<Map<String, dynamic>?> fetchMyProfile() async {
    final url = Uri.parse(AppConfig.profileEndpoint);

    try {
      final response = await _apiClient.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == "OK") {
          return decoded['data'];
        }
      }
      return null;
    } catch (e) {
      print("💥 Erreur UserService (me) : $e");
      return null;
    }
  }
}