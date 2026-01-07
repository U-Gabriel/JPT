import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/object_profile.dart';
import 'package:app/app_config.dart';

class ObjectProfileService {
  final String baseUrl =  AppConfig.baseUrl;


  Future<List<ObjectProfile>> fetchObjectProfilesList(String personId, String token) async {
    final url = Uri.parse(AppConfig.objectProfilesEndpointList());

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id_person": int.tryParse(personId) ?? 0,
      }),
    );

    if (response.statusCode == 200) {

      final decoded = json.decode(response.body);

      List<dynamic> data = decoded["data"] ?? [];

      return data.map((json) => ObjectProfile.fromJson(json)).toList();
    } else {
      throw Exception('Erreur de chargement: ${response.statusCode}');
    }
  }

  Future<List<ObjectProfile>> fetchObjectProfilesListFavoris(String personId, String token) async {
    final url = Uri.parse(AppConfig.objectProfilesEndpointListFavoris());

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id_person": int.tryParse(personId) ?? 0,
      }),
    );

    if (response.statusCode == 200) {

      final decoded = json.decode(response.body);

      List<dynamic> data = decoded["data"] ?? [];

      return data.map((json) => ObjectProfile.fromJson(json)).toList();
    } else {
      throw Exception('Erreur de chargement: ${response.statusCode}');
    }
  }

  Future<void> updateObjectProfile({
    required String id,
    required Map<String, dynamic> body,
    required String token,
  }) async {
    final url = Uri.parse(AppConfig.updateObjectProfileEndpoint(id));

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur mise à jour : ${response.statusCode}");
    }
  }

  Future<ObjectProfile> fetchObjectProfileDetails(int plantId, String token) async {
    final url = Uri.parse(AppConfig.objectProfilesEndpointDetails());

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id_object_profile": plantId,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      List<dynamic> data = decoded["data"] ?? [];

      print(data);

      if (data.isEmpty) {
        throw Exception("Aucun détail trouvé pour l'objet $plantId");
      }

      return ObjectProfile.fromJson(data.first);
    } else {
      throw Exception('Erreur de chargement: ${response.statusCode}');
    }
  }



}
