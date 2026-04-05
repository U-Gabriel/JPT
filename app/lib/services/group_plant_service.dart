import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../models/plant_group.dart';

class GroupPlantService {

  Future<bool> createGroup({
    required int idPerson,
    required int idObjectProfile,
    required int idPlantType,
    required String title,
    required double fertility,
    required double temperature,
    required double humidityAir,
    required int priority,
    required int wateringTime,
    required int wateringPeriodOpen,
    required String token,
  }) async {
    final url = Uri.parse(AppConfig.GroupPlantTypeEndpointCreate());

    final body = jsonEncode({
      "id_person": idPerson,
      "id_object_profile": idObjectProfile,
      "id_plant_type": idPlantType,
      "title": title,
      "conductivity_electrique_fertility_sensor": fertility,
      "temperature_sensor_extern": temperature,
      "humidity_air_sensor": humidityAir,
      "priority_plant": priority,
      "watering_time": wateringTime,
      "watering_period_open": wateringPeriodOpen
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Erreur création groupe: $e");
      return false;
    }
  }



  Future<List<PlantGroup>> getGroupsResume(int idPerson, int idObjectProfile, String token) async {
    final url = Uri.parse(AppConfig.GroupPlantTypeEndpointGet());

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id_person": idPerson,
          "id_object_profile": idObjectProfile
        }),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['data'] ?? [];
        return data.map((item) => PlantGroup.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print("Erreur GroupPlantService: $e");
      return [];
    }
  }

  Future<bool> deleteGroup(int idPerson, int idGroup, String token) async {
    final url = Uri.parse(AppConfig.GroupPlantTypeEndpointDelete());

    try {

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id_person": idPerson,
          "id_group_plant_type": idGroup
        }),
      );
      print("STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print("STATUS CODE: ${response.statusCode}");
        print("RESPONSE BODY: ${response.body}");
        return decoded['data'] != null && decoded['data']['success'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> assignGroup({
    required int idPerson,
    required int idObjectProfile,
    required int idGroup,
    required bool isStandard,
    required String token,
  }) async {
    final url = Uri.parse(AppConfig.GroupPlantTypeEndpointAssign());

    // Construction du body flexible
    final Map<String, dynamic> body = {
      "id_person": idPerson,
      "id_object_profile": idObjectProfile,
      "is_standard": isStandard,
    };

    // On ajoute l'ID du groupe (optionnel pour le standard selon tes specs, mais propre à inclure)
    body["id_group_plant_type"] = idGroup;

    try {
      final response = await http.patch( // Utilisation de PATCH comme indiqué
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded['data'] != null && decoded['data']['success'] == true;
      }
      return false;
    } catch (e) {
      print("Erreur assignation: $e");
      return false;
    }
  }

}