import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/app_config.dart';
import '../models/plant_type.dart'; // Importez votre modèle ici

class PlantService {

  Future<List<PlantType>> searchPlants(String query, String token) async {
    final url = Uri.parse(AppConfig.PlantTypeEndpointSearch());

    if (query.isEmpty) return [];

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"title": query}),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> data = decoded['data'] ?? [];

        // On transforme chaque Map du JSON en objet PlantType
        return data.map((json) => PlantType.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Erreur recherche plante: $e");
      return [];
    }
  }

  Future<PlantType?> getDescriptionPlantType(int id, String token) async {
    // Remplacez par votre endpoint réel dans AppConfig si nécessaire
    final url = Uri.parse('${AppConfig.baseUrl}/plant_type/description/byid');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        // Attention : on va chercher dans decoded['data']
        return PlantType.fromJson(decoded['data']);
      }
      return null;
    } catch (e) {
      print("Erreur GetDescription: $e");
      return null;
    }
  }
}