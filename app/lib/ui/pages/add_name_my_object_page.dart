import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/models/plant_type.dart';
import 'package:app/services/plant_service.dart';
import 'package:app/app_config.dart';
import 'package:app/ui/pages/widget/tools/step_progress_bar.dart';

class AddNameMyObjectPage extends StatefulWidget {
  const AddNameMyObjectPage({Key? key}) : super(key: key);

  @override
  State<AddNameMyObjectPage> createState() => _AddNameMyObjectPageState();
}

class _AddNameMyObjectPageState extends State<AddNameMyObjectPage> {
  final PlantService _plantService = PlantService();
  final TextEditingController _nameController = TextEditingController();
  late Future<PlantType?> _plantFuture;

  // Par défaut, si l'argument ne passe pas
  String plantTitle = "votre plante";
  int? plantId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Récupération de la Map envoyée par la page précédente
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args is Map<String, dynamic>) {
      plantId = args['id'];
      setState(() {
        plantTitle = args['title'] ?? "votre plante";
      });

      if (plantId != null) {
        _plantFuture = _loadPlantData(plantId!);
      }
    }
  }

  Future<PlantType?> _loadPlantData(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return _plantService.getDescriptionPlantType(id, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Validez votre objet"),
      ),
      body: FutureBuilder<PlantType?>(
        future: _plantFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Erreur lors du chargement des détails"));
          }

          final plant = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepProgressBar(percent: 0.25),
                const SizedBox(height: 30),

                // 1. La phrase personnalisée avec le titre reçu immédiatement
                Text(
                  "Super ! Votre $plantTitle a besoin d'un petit nom.",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // 2. Champ de saisie obligatoire
                RichText(
                  text: const TextSpan(
                    text: "Donnez un nom à votre objet",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                    children: [
                      TextSpan(text: " *", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Ex: Mon beau Ficus",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.edit, color: Colors.green),
                  ),
                ),

                const SizedBox(height: 40),
                const Divider(),
                const SizedBox(height: 20),

                // 3. Section Détails (Photos + Description)
                const Text("Photos de référence", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: plant.avatars?.length ?? 0,
                    itemBuilder: (context, index) {
                      final avatar = plant.avatars![index];
                      return Container(
                        margin: const EdgeInsets.only(right: 15),
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))
                          ],
                          image: DecorationImage(
                            image: NetworkImage(Uri.parse(AppConfig.baseUrlDataset).resolve(avatar.picturePath).toString()),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),

                const Text("En savoir plus", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  plant.description ?? "Pas de description disponible pour cette espèce.",
                  style: const TextStyle(color: Colors.black54, height: 1.5, fontSize: 15),
                ),

                const SizedBox(height: 40),

                // 4. Bouton de validation
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Le nom est obligatoire !"), backgroundColor: Colors.red),
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/add_wifi_information',
                          arguments: {
                            'id': plantId, // L'id que tu as récupéré via l'API
                            'name': _nameController.text, // Le nom personnalisé que l'user vient de donner
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Continuer", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}