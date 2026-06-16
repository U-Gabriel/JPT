import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import 'api_client.dart';

class TagService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> fetchTags() async {
    final response = await _apiClient.get(Uri.parse(AppConfig.tagsEndpoint));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'];
    }
    return [];
  }

  Future<List<dynamic>> fetchTagsLvlOne() async {
    final response = await _apiClient.get(Uri.parse(AppConfig.tagsLvlOneEndpoint));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'];
    }
    return [];
  }

}