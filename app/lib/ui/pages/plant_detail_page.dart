import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/object_profile_service.dart';
import '../../bloc/plant_detail/plant_detail_bloc.dart';
import '../../bloc/plant_detail/plant_detail_event.dart';
import '../../bloc/plant_detail/plant_detail_state.dart'; // Assure-toi d'importer le state
import '../../../app_config.dart';
import '../../models/object_profile.dart';
import 'package:app/ui/pages/widget/plant_card_favorite/plant_control_switches_widget.dart';

class PlantDetailPage extends StatelessWidget {
  final int plantId;
  const PlantDetailPage({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().accessToken;
    if (token == null) return const Scaffold(body: Center(child: Text("Session expirée")));

    return BlocProvider(
      create: (_) => PlantDetailBloc(
        service: ObjectProfileService(),
        plantId: plantId,
        token: token,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Builder( // On utilise Builder pour accéder au bloc créé juste au-dessus
          builder: (context) {
            final bloc = context.read<PlantDetailBloc>();

            // On remet le StreamBuilder pour le côté dynamique / Polling
            return StreamBuilder<ObjectProfile>(
              stream: bloc.plantStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                }

                // Si on n'a pas encore de données, on regarde si le Bloc a un état initial
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final plant = snapshot.data!;
                final details = plant.plantDetails;
                final imageUrl = details.imagePath != null
                    ? Uri.parse(AppConfig.baseUrlDataset).resolve(details.imagePath!).toString()
                    : null;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // --- APPBAR RESPONSIVE ---
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height * 0.30,
                      pinned: true,
                      actions: [
                        IconButton(
                          icon: Icon(
                            plant.isFavorite ? Icons.star : Icons.star_border,
                            color: plant.isFavorite ? Colors.yellow[600] : Colors.white,
                          ),
                          onPressed: () {
                            final userIdString = context.read<AuthProvider>().userId;
                            final userId = int.tryParse(userIdString ?? '') ?? 0;

                            print("Envoi de ToggleFavorite pour User: $userId");

                            // On récupère l'état AVANT le changement pour le message
                            final bool wasFavorite = plant.isFavorite;

                            // On envoie l'ordre au bloc
                            context.read<PlantDetailBloc>().add(ToggleFavorite(userId));

                            // On affiche un message cohérent avec l'action entreprise
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(!wasFavorite ? "Ajout aux favoris..." : "Retrait des favoris..."),
                                backgroundColor: !wasFavorite ? Colors.green : Colors.orange,
                                duration: const Duration(milliseconds: 800),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_input_component, color: Colors.white),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/group_plant_type',
                              arguments: plant.idObjectProfile, // On passe l'ID de l'objet
                            );
                          },
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(plant.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(blurRadius: 10, color: Colors.black)]
                            )
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            imageUrl != null
                                ? Image.network(imageUrl, fit: BoxFit.cover)
                                : Container(color: Colors.green),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black54, Colors.transparent],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- CONTENU ---
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(plant, context),
                            const SizedBox(height: 16),
                            _buildConnectionStatus(plant),
                            const SizedBox(height: 16),
                            _buildAnalysisCard(plant),
                            const SizedBox(height: 24),
                            _buildModeBanner(plant),
                            const SizedBox(height: 24),

                            // Tes switchs dynamiques
                            PlantControlSwitches(plant: plant),

                            const SizedBox(height: 32),
                            const Text("État des capteurs",
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)
                            ),
                            const SizedBox(height: 16),

                            // Grille responsive corrigée (FittedBox)
                            _buildSensorGrid(plant),

                            const SizedBox(height: 32),
                            _buildInfoSection("À propos", plant.description ?? "Pas de description"),
                            _buildInfoSection("Conseil d'entretien", plant.advise ?? "Aucun conseil"),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE ---

  Widget _buildHeader(ObjectProfile plant, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plant.plantDetails.typeTitle,
                  style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              // --- BOUTON INFO PRO ---
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/plant_detail_known',
                    arguments: plant.plantDetails.typeId,
                  );
                },
                child: Icon(Icons.info_outline, size: 20, color: Colors.green.withOpacity(0.7)),
              ),
              Text("Groupe: ${plant.plantDetails.groupTitle}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ],
          ),
        ),
        Chip(
          backgroundColor: _getHealthColor(plant.state).withOpacity(0.1),
          side: BorderSide(color: _getHealthColor(plant.state)),
          label: Text(
            getStateText(plant.state).toUpperCase(),
            style: TextStyle(color: _getHealthColor(plant.state), fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisCard(ObjectProfile plant) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green[100]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.green[700]),
              const SizedBox(width: 12),
              const Text("ANALYSE IA", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ],
          ),
          const SizedBox(height: 12),
          Text(plant.adviceRealtime ?? "Analyse en cours...",
              style: TextStyle(color: Colors.green[900], fontSize: 15, height: 1.5)),
        ],
      ),
    );
  }

  // CORRECTION DU GRIDVIEW POUR L'ADAPTABILITÉ
  Widget _buildSensorGrid(ObjectProfile plant) {
    final sensors = plant.sensors;

    // Petit helper pour éviter les crashs si une valeur est nulle
    String format(double? val) => val != null ? val.toStringAsFixed(1) : '--';

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.4, // On ajuste un peu la hauteur
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildSensorTile("Température", "${format(sensors.averages['temp'])}°C", sensors.targets['temp'], sensors.averages['temp'], Icons.thermostat, "°C"),
        _buildSensorTile("Humidité Sol", "${format(sensors.averages['hum_sol'])}%", sensors.targets['hum_sol'], sensors.averages['hum_sol'], Icons.water_drop, "%"),
        _buildSensorTile("Humidité Air", "${format(sensors.averages['hum_air'])}%", sensors.targets['hum_air'], sensors.averages['hum_air'], Icons.cloud, "%"),
        _buildSensorTile("Fertilité", format(sensors.averages['fertility']), sensors.targets['fertility'], sensors.averages['fertility'], Icons.science, ""),
      ],
    );
  }

  Widget _buildSensorTile(String label, String value, dynamic target, double? average, IconData icon, String unit) {
    return Container(
      padding: const EdgeInsets.all(12), // Réduit un peu le padding (était à 16)
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Utilise le minimum de place
        children: [
          Icon(icon, size: 20, color: Colors.green), // Réduit un peu l'icône (était à 22)
          const SizedBox(height: 4), // Remplace Spacer() par un petit espace fixe
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Sécurité si le texte est long
              style: const TextStyle(fontSize: 11, color: Colors.grey)
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          if (target != null)
            Text("Cible: $target",
              style: TextStyle(fontSize: 9, color: Colors.grey[400]),
              maxLines: 1,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content, style: TextStyle(color: Colors.grey[700], height: 1.6, fontSize: 15)),
        ],
      ),
    );
  }

  Color _getHealthColor(int? state) {
    if (state == null) return Colors.grey;
    if (state <= 2) return Colors.green;
    if (state <= 4) return Colors.orange;
    return Colors.red;
  }


  Widget _buildModeBanner(ObjectProfile plant) {
    final bool isAuto = plant.isAutomatic ?? false;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isAuto ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isAuto ? Colors.green[200]! : Colors.orange[200]!,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isAuto ? Icons.auto_fix_high : Icons.handyman,
                color: isAuto ? Colors.green[700] : Colors.orange[700],
              ),
              const SizedBox(width: 12),
              Text(
                isAuto ? "MODE AUTOMATIQUE ACTIVÉ" : "MODE MANUEL ACTIVÉ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1.1,
                  color: isAuto ? Colors.green[800] : Colors.orange[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isAuto
                ? "Le mode automatique est activé : le pot se comportera selon les paramètres optimaux définis pour votre plante."
                : "Attention ! Le pot ne prendra aucune décision d'arrosage. Ce mode permet la surveillance et l'arrosage à distance. Pour changer de mode appuyer su le bouton rouge votre objet. Note : l'économie de batterie est désactivée.",
            style: TextStyle(
              color: isAuto ? Colors.green[900] : Colors.orange[900],
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  bool _isConnectionStable(String? lastWatering) {
    if (lastWatering == null) return false;
    try {
      final lastDate = DateTime.parse(lastWatering);
      final difference = DateTime.now().difference(lastDate).inDays;
      return difference <= 7;
    } catch (e) {
      return false;
    }
  }

  Widget _buildConnectionStatus(ObjectProfile plant) {
    final bool isStable = _isConnectionStable(plant.lastWatering);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isStable ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isStable ? Colors.green[200]! : Colors.red[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isStable ? Icons.wifi_tethering : Icons.wifi_tethering_off,
            color: isStable ? Colors.green[700] : Colors.red[700],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isStable
                  ? "Objet bien connecté à l'application"
                  : "Perte de contact avec la plante, veuillez vérifier son état ! Wifi ou connexion impossible !",
              style: TextStyle(
                color: isStable ? Colors.green[800] : Colors.red[800],
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
          if (isStable)
            Icon(Icons.check_circle, color: Colors.green[700], size: 16),
        ],
      ),
    );
  }
}