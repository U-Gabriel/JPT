import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../app_config.dart';
import '../models/avatar.dart';
import 'api_client.dart';

class AvatarService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Avatar>> fetchAvatars() async {
    final response = await _apiClient.get(
      Uri.parse(AppConfig.avatarListEndpoint),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<dynamic> data = decoded["data"] ?? [];
      return data.map((json) => Avatar.fromJson(json)).toList();
    }
    throw Exception("Erreur lors de la récupération des avatars");
  }

  Future<bool> uploadCustomAvatar({
    required int idObjectProfile,
    required File imageFile,
  }) async {
    final url = Uri.parse(AppConfig.avatarUpdateEndpoint);

    try {
      // 1. On prépare le fichier EXACTEMENT comme tu le faisais avant, avec la clé 'picture'
      final multipartFile = await http.MultipartFile.fromPath(
        'picture', // 👈 C'est exactement ta ligne d'origine !
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      );

      // 2. On envoie le tout à notre ApiClient magique
      final response = await _apiClient.multipart(
        method: "POST",
        url: url,
        fields: {
          'id_object_profile': idObjectProfile.toString(), // Ton champ texte d'origine
        },
        files: [multipartFile], // Ton fichier d'origine
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded['status'] == "OK";
      }
      return false;
    } catch (e) {
      debugPrint("Erreur Upload: $e");
      return false;
    }
  }

}