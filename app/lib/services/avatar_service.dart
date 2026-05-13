import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../models/avatar.dart';

class AvatarService {
  Future<List<Avatar>> fetchAvatars(String token) async {
    final response = await http.get(
      Uri.parse(AppConfig.avatarListEndpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<dynamic> data = decoded["data"] ?? [];
      return data.map((json) => Avatar.fromJson(json)).toList();
    }
    throw Exception("Erreur lors de la récupération des avatars");
  }
}