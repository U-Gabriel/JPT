import 'package:app/models/plant_type.dart';
import 'package:app/ui/pages/widget/tools/step_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_config.dart';
import '../../services/plant_service.dart';

class AddMyObjectPage extends StatefulWidget {
  const AddMyObjectPage({Key? key}) : super(key: key);

  @override
  State<AddMyObjectPage> createState() => _AddMyObjectPageState();
}

class _AddMyObjectPageState extends State<AddMyObjectPage> {
  final PlantService _plantService = PlantService();
  final TextEditingController _plantController = TextEditingController();

  // On stocke l'objet plante sélectionné
  PlantType? _selectedPlant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Barre de progression
            const StepProgressBar(percent: 0),
            const SizedBox(height: 30),

            // 2. Titre
            const Text(
              'Associez votre objet',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 3. Phrase d'explication (corrigée)
            const Text(
              "Si vous possédez un objet connecté JackPote, vous êtes au bon endroit ! Commençons par associer votre objet à l'application. Pour débuter : à quelle plante cet objet sera-t-il destiné ?",
              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 40),

            // 4. Champ de recherche avec Autocomplete (API)
            const Text("Nom de la plante", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Autocomplete<PlantType>(
              displayStringForOption: (PlantType option) => option.title,
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text == '') {
                  return const Iterable<PlantType>.empty();
                }
                // Appel à votre API
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('token');

                final results = await _plantService.searchPlants(textEditingValue.text, token!);
                return results.cast<PlantType>();
              },
              onSelected: (PlantType selection) {
                setState(() {
                  _selectedPlant = selection;
                });
                // Redirection automatique vers la page suivante avec les infos
                Navigator.pushNamed(
                    context,
                    '/add_name_my_object',
                    arguments: {
                    'id': selection.idPlantType,
                    'title': selection.title,
                },
                );
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Rechercher une plante (ex: Ficus...)',
                    prefixIcon: const Icon(Icons.search, color: Colors.green),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 8.0,
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300), // Augmenté un peu pour le confort
                      child: Container(
                        width: MediaQuery.of(context).size.width - 48,
                        color: Colors.white,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (BuildContext context, int index) {
                            final option = options.elementAt(index);
                            final String? pathPicture = option.pathPicture; // On récupère le chemin

                            return ListTile(
                              onTap: () => onSelected(option),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[100],
                                  child: pathPicture != null
                                      ? Image.network(
                                    // Utilisation de votre logique AppConfig
                                    Uri.parse(AppConfig.baseUrlDataset)
                                        .resolve(pathPicture)
                                        .toString(),
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, color: Colors.grey),
                                  )
                                      : const Icon(Icons.local_florist, color: Colors.green),
                                ),
                              ),
                              title: Text(
                                option.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                option.description ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // 5. Bouton "Je ne trouve pas ma plante"
            TextButton(
              onPressed: () {
                // Action si la plante n'existe pas
              },
              child: const Text("Je ne trouve pas ma plante",
                  style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline)
              ),
            ),

            const SizedBox(height: 50),
            const Divider(),
            const SizedBox(height: 30),

            // 6. Section Boutique
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    "Si vous n'avez pas encore acheté votre JackPote, allons dans notre boutique pour nous dégoter votre pot !",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/buy_my_object'),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text("Aller à la boutique"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}