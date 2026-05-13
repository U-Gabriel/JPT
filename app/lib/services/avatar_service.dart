import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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

  Future<bool> uploadCustomAvatar({
    required int idObjectProfile,
    required File imageFile,
    required String token,
  }) async {
    final url = Uri.parse(AppConfig.avatarUpdateEndpoint);

    var request = http.MultipartRequest("POST", url);
    request.headers['Authorization'] = 'Bearer $token';

    // Ajout des champs texte
    request.fields['id_object_profile'] = idObjectProfile.toString();

    // Ajout du fichier
    request.files.add(await http.MultipartFile.fromPath(
      'picture',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'), // ou 'png' selon le fichier
    ));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

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