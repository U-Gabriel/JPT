import 'package:app/l10n/generated/app_localizations.dart';
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
        title: Text(
          AppLocalizations.of(context)!.newObjectD,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
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
            Text(
              AppLocalizations.of(context)!.addObjectMainTitle,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 3. Phrase d'explication (corrigée)
            Text(
            AppLocalizations.of(context)!.addObjectExplanation,
              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 40),

            // 4. Champ de recherche avec Autocomplete (API)
            Text(AppLocalizations.of(context)!.addObjectFieldName, style: TextStyle(fontWeight: FontWeight.bold)),
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

                final results = await _plantService.searchPlants(textEditingValue.text);
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
                    hintText: AppLocalizations.of(context)!.addObjectFieldHint,
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

            // 5. Section Boutons d'alternatives (Version Verticale & Design Pro)
            const SizedBox(height: 20),

            // Premier bouton : Je ne trouve pas ma plante
            SizedBox(
              width: double.infinity,
              height: 48, // Bouton plus grand et plus cliquable
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/add_name_my_object',
                    arguments: {
                      'id': AppConfig.defaultPlantId,
                      'title': AppConfig.defaultPlantTitle,
                    },
                  );
                },
                icon: const Icon(Icons.help_outline, size: 18, color: Colors.grey),
                label: Text(
                  AppLocalizations.of(context)!.addObjectBtnNotFound,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12), // Espace entre les deux gros boutons

            // Deuxième bouton : Usage hors-végétal
            SizedBox(
              width: double.infinity,
              height: 48, // Même taille pour une belle harmonie visuelle
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/add_name_spe_my_object',
                    arguments: {
                      'id': AppConfig.defaultPlantId,
                      'title': "Objet connecté",
                    },
                  );
                },
                icon: const Icon(Icons.devices_other, size: 18, color: Colors.green),
                label: Text(
                  AppLocalizations.of(context)!.addObjectBtnOtherUsage,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.green.withOpacity(0.05),
                  side: BorderSide(color: Colors.green.withOpacity(0.2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
                  Text(
                    AppLocalizations.of(context)!.addObjectShopText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/buy_my_object'),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: Text(AppLocalizations.of(context)!.addObjectShopBtn),
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