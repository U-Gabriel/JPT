import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';

class TagService {
  Future<List<dynamic>> fetchTags(String token) async {
    final response = await http.get(
      Uri.parse(AppConfig.tagsEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'];
    }
    return [];
  }

}