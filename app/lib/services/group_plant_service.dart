import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../models/plant_group.dart';

class GroupPlantService {
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
}