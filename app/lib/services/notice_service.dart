import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../models/notice.dart';
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

  /// Récupère la liste des remarques de l'utilisateur connecté
  Future<List<Notice>> getUserNotices() async {
    final response = await _apiClient.get(
      Uri.parse(AppConfig.noticeByUserEndpoint)
    );

    final Map<String, dynamic> data = json.decode(response.body);
    if (data['code'] == 200 && data['data'] != null) {
      final List list = data['data'];
      return list.map((e) => Notice.fromJson(e)).toList();
    }
    return [];
  }

  /// Supprime une remarque par son ID
  Future<bool> deleteNotice(int idNotice) async {
    final response = await _apiClient.post(
      Uri.parse(AppConfig.noticeDeleteEndpoint),
      body: jsonEncode({"id_notice": idNotice}),
    );

    final Map<String, dynamic> data = json.decode(response.body);
    return data['code'] == 200;
  }

}