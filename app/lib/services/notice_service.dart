import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import 'api_client.dart';

class NoticeService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> createNotice({
    required int idPerson,
    required String title,
    required String content,
    int? idObjectProfile,
    required int idTag,
  }) async {
    final response = await _apiClient.post(
      Uri.parse(AppConfig.noticeCreateEndpoint),
      body: jsonEncode({
        "id_person": idPerson,
        "title": title,
        "content": content,
        "id_object_profile": idObjectProfile,
        "id_tag": idTag,
      }),
    );

    return json.decode(response.body);
  }
}