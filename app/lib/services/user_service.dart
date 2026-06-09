import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/app_config.dart';

class UserService {
  Future<Map<String, dynamic>?> fetchMyProfile(String token) async {
    final url = Uri.parse(AppConfig.profileEndpoint);

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

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