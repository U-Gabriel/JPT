import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/object_profile.dart';
import 'package:app/app_config.dart';

class ObjectProfileService {
  final String baseUrl =  AppConfig.baseUrl;

  Future<int?> createObjectProfileShort({
    required String title,
    required int idObject,
    required int idPlantType,
    required int idPerson,
    required String token,
  }) async {
    final url = Uri.parse(AppConfig.objectProfilesEndpointCreate());

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "title": title,
        "id_object": idObject,
        "id_plant_type": idPlantType,
        "id_person": idPerson,
        "activate": 0
      }),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['status'] == "OK") {
        return decoded['data']['id_object_profile'];
      }
    }

    // Si on arrive ici, c'est qu'il y a un souci
    throw Exception("Erreur lors de la création du profil");
  }


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

  Future<bool> updateObjectProfile({
    required int idPerson,
    required int idObjectProfile,
    required Map<String, dynamic> otherFields,
    required String token,
  }) async {
    final url = Uri.parse(AppConfig.objectProfileEndpointUpdate());

    // On crée le body avec les champs obligatoires
    final Map<String, dynamic> fullBody = {
      "id_person": idPerson,
      "id_object_profile": idObjectProfile,
    };

    fullBody.addAll(otherFields);

    try {
      final response = await http.patch( // Utilise patch ou post selon ton API
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fullBody),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded['status'] == "OK";
      }
      return false;
    } catch (e) {
      print("Erreur lors de l'update : $e");
      return false;
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

  Future<bool> deleteObjectProfile({
    required int idPerson,
    required int idObjectProfile,
    required String token,
  }) async {
    final url = Uri.parse(AppConfig.objectProfilesEndpointDelete());

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id_person": idPerson,
          "id_object_profile": idObjectProfile,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded['status'] == "OK" && decoded['data']['success'] == true;
      }
      return false;
    } catch (e) {
      print("Erreur lors de la suppression du profil : $e");
      return false;
    }
  }



}
