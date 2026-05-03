import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';

class NoticeService {

  Future<Map<String, dynamic>> createNotice({
    required int idPerson,
    required String title,
    required String content,
    int? idObjectProfile,
    required int idTag,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse(AppConfig.noticeCreateEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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