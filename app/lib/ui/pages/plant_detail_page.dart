import 'package:app/ui/pages/widget/popup/delete_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // AJOUT DE L'IMPORT
import '../../../providers/auth_provider.dart';
import '../../../services/object_profile_service.dart';
import '../../bloc/plant_detail/plant_detail_bloc.dart';
import '../../bloc/plant_detail/plant_detail_event.dart';
import '../../bloc/plant_detail/plant_detail_state.dart';
import '../../../app_config.dart';
import '../../models/object_profile.dart';
import 'package:app/ui/pages/widget/plant_card_favorite/plant_control_switches_widget.dart';

class PlantDetailPage extends StatelessWidget {
  final int plantId;
  const PlantDetailPage({super.key, required this.plantId});

  // --- NOUVELLE MÉTHODE SHIMMER ---
  Widget _buildLoadingShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.30,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.white),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 30, width: 200, color: Colors.white),
                  const SizedBox(height: 16),
                  Container(height: 50, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
                  const SizedBox(height: 16),
                  Container(height: 100, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
                  const SizedBox(height: 32),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: List.generate(4, (index) => Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        body: Builder(
          builder: (context) {
            final bloc = context.read<PlantDetailBloc>();

            return StreamBuilder<ObjectProfile>(
              stream: bloc.plantStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                }

                if (!snapshot.hasData) {
                  return _buildLoadingShimmer(context); // REMPLACEMENT ICI
                }

                final plant = snapshot.data!;
                final details = plant.plantDetails;
                final imageUrl = details.imagePath != null
                    ? Uri.parse(AppConfig.baseUrlDataset).resolve(details.imagePath!).toString()
                    : null;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height * 0.30,
                      pinned: true,
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.wifi_find, color: Colors.white),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/modification_wifi_my_object',
                              arguments: {
                                'objectProfileId': plant.idObjectProfile,
                                'title': plant.title,
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.white),
                          onPressed: () => _handleDelete(context, plant),
                        ),
                        IconButton(
                          icon: Icon(
                            plant.isFavorite ? Icons.star : Icons.star_border,
                            color: plant.isFavorite ? Colors.yellow[600] : Colors.white,
                          ),
                          onPressed: () {
                            final userIdString = context.read<AuthProvider>().userId;
                            final userId = int.tryParse(userIdString ?? '') ?? 0;
                            final bool wasFavorite = plant.isFavorite;
                            context.read<PlantDetailBloc>().add(ToggleFavorite(userId));
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
                                arguments: {
                                  'objectProfileId': plant.idObjectProfile,
                                  'plantId': plant.plantDetails.typeId,
                                }
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
                            PlantControlSwitches(plant: plant),
                            const SizedBox(height: 32),
                            const Text("État des capteurs",
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)
                            ),
                            const SizedBox(height: 16),
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

  // --- GARDE LE RESTE DU CODE IDENTIQUE ---
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

  Widget _buildSensorGrid(ObjectProfile plant) {
    final sensors = plant.sensors;
    String format(double? val) => val != null ? val.toStringAsFixed(1) : '--';

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildSensorTile("Température", "${format(sensors.averages['temp'])}°C", sensors.targets['temp'], sensors.averages['temp'], Icons.thermostat, "°C"),
        _buildSensorTile("Humidité Sol", "${format(sensors.averages['fertility'])}%", sensors.targets['fertility'], sensors.averages['fertility'], Icons.water_drop, "%"),
        _buildSensorTile("Humidité Air", "${format(sensors.averages['hum_air'])}%", sensors.targets['hum_air'], sensors.averages['hum_air'], Icons.cloud, "%"),
        _buildSensorTile("Fertilité", format(sensors.averages['fertility']), sensors.targets['fertility'], sensors.averages['fertility'], Icons.science, ""),
      ],
    );
  }

  Widget _buildSensorTile(String label, String value, dynamic target, double? average, IconData icon, String unit) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(height: 4),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                : "Attention ! Le pot ne prendra aucune décision d'arrosage. Ce mode permet la surveillance et l'arrosage à distance.",
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

  void _handleDelete(BuildContext context, ObjectProfile plant) {
    final authProvider = context.read<AuthProvider>();
    final userId = int.tryParse(authProvider.userId ?? '') ?? 0;
    final token = authProvider.accessToken ?? '';

    DeleteConfirmDialog.show(
      context,
      title: "Supprimer les réglages",
      message: "Voulez-vous vraiment supprimer votre plante ${plant.title} ?",
      onConfirm: () async {
        final statusCode = await ObjectProfileService().deleteObjectProfile(
          idPerson: userId,
          idObjectProfile: plant.idObjectProfile,
          token: token,
        );

        if (!context.mounted) return;

        switch (statusCode) {
          case 200:
            _showSnack(context, "Profil supprimé avec succès", Colors.green);
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
          case 403:
            _showSnack(context, "Impossible : l'objet est connecté et en mode AUTO.", Colors.orange);
            break;
          default:
            _showSnack(context, "Erreur lors de la suppression.", Colors.red);
        }
      },
    );
  }

  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  bool _isConnectionStable(String? dateString, {int maxDays = 1}) {
    if (dateString == null) return false;
    try {
      final lastDate = DateTime.parse(dateString).toLocal();
      final now = DateTime.now();
      return now.difference(lastDate).inDays <= maxDays;
    } catch (e) {
      return false;
    }
  }

  Widget _buildConnectionStatus(ObjectProfile plant) {
    final bool isStable = _isConnectionStable(plant.lastUpdate, maxDays: 1) ||
        _isConnectionStable(plant.lastWatering, maxDays: 6);

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
                  : "Perte de contact avec la plante !",
              style: TextStyle(
                color: isStable ? Colors.green[800] : Colors.red[800],
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}