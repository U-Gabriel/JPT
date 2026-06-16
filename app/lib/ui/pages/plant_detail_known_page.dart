import 'package:app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/plant_type.dart';
import '../../../services/plant_service.dart';
import '../../../app_config.dart';

class PlantDetailKnownPage extends StatefulWidget {
  final int plantId;
  const PlantDetailKnownPage({super.key, required this.plantId});

  @override
  State<PlantDetailKnownPage> createState() => _PlantDetailKnownPageState();
}

class _PlantDetailKnownPageState extends State<PlantDetailKnownPage> {
  final PlantService _plantService = PlantService();
  late Future<PlantType?> _futurePlant;

  final PageController _pageController = PageController();
  int _currentPage = 0; // Pour savoir quelle bulle colorer

  @override
  void initState() {
    super.initState();
    _futurePlant = _loadData();
  }

  Future<PlantType?> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return _plantService.getDescriptionPlantType(widget.plantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8), // Blanc cassé verdâtre très pro
      body: FutureBuilder<PlantType?>(
        future: _futurePlant,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }
          final plant = snapshot.data;
          if (plant == null) return Center(child: Text(AppLocalizations.of(context)!.plantNotFound));

          return CustomScrollView(
            slivers: [
              // --- HEADER CARROUSEL ---
              SliverAppBar(
                expandedHeight: 350,
                pinned: true,
                backgroundColor: Colors.green[800],
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImageHeader(plant),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0), // C'est ici qu'on gère la marge
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),

              // --- CONTENU ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(plant),
                      const SizedBox(height: 25),
                      _buildQuickMetrics(plant),
                      const SizedBox(height: 30),
                      _buildSectionTitle(AppLocalizations.of(context)!.descriptionD),
                      Text(plant.description ?? "",
                          style: TextStyle(color: Colors.grey[800], height: 1.6, fontSize: 15)),
                      const SizedBox(height: 30),
                      _buildSectionTitle(AppLocalizations.of(context)!.expertTips),
                      _buildAdviseCard(plant.advise),
                      const SizedBox(height: 30),
                      _buildSectionTitle(AppLocalizations.of(context)!.needsAndEnv),
                      _buildEnvironmentGrid(plant),
                      const SizedBox(height: 30),
                      _buildSectionTitle(AppLocalizations.of(context)!.lifeCalendar),
                      _buildSeasonBar(plant),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCTION ---

  Widget _buildImageHeader(PlantType plant) {
    // Si la liste d'avatars est nulle ou vide, on affiche directement l'image de secours
    if (plant.avatars == null || plant.avatars!.isEmpty) {
      return _buildFallbackImage();
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: plant.avatars!.length,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemBuilder: (context, index) {
            final url = Uri.parse(AppConfig.baseUrlDataset)
                .resolve(plant.avatars![index].pathPicture)
                .toString();

            return Image.network(
              url,
              fit: BoxFit.cover,
              // --- PENDANT LE CHARGEMENT (SHIMMER) ---
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.white),
                );
              },
              // --- EN CAS D'ERREUR (VOTRE LOGO SVG) ---
              errorBuilder: (context, error, stackTrace) {
                return _buildFallbackImage();
              },
            );
          },
        ),

        // Les bulles indicatrices (restent inchangées)
        if (plant.avatars!.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                plant.avatars!.length,
                    (index) => _buildBulletIndicator(index),
              ),
            ),
          ),
      ],
    );
  }

// Petit helper pour construire l'image de secours proprement
  Widget _buildFallbackImage() {
    return Container(
      color: Colors.green[50], // Fond léger pour que le logo ressorte
      child: Center(
        child: SvgPicture.asset(
          'assets/logo/favicon_green.svg',
          width: 80, // Taille ajustée pour le header
          fit: BoxFit.contain,
        ),
      ),
    );
  }

// Helper pour les bulles (pour nettoyer le code)
  Widget _buildBulletIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildTitleSection(PlantType plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                plant.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                  color: Color(0xFF1B311E), // Un vert très foncé presque noir
                ),
              ),
            ),
            // Badge de catégorie
            if (plant.category != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  plant.category!.split(';').first.toUpperCase(),
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              )
          ],
        ),
        const SizedBox(height: 8),

        // --- NOM SCIENTIFIQUE ---
        if (plant.scientistName != null)
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)!.scientificName,
                  style: const TextStyle(
                    color: Colors.black, // Le libellé en noir
                    fontWeight: FontWeight.bold, // Optionnel : un peu plus gras pour bien distinguer
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: plant.scientistName ?? AppLocalizations.of(context)!.unknownD,
                  style: const TextStyle(
                    color: Colors.green, // La valeur en vert
                    fontStyle: FontStyle.italic, // Très recommandé pour les noms latins
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 4),

        // --- FAMILLE ---
        Row(
          children: [
            const Icon(Icons.account_tree_outlined, size: 14, color: Colors.grey),
            const SizedBox(width: 6),
            Text(
              AppLocalizations.of(context)!.plantFamilyLabel(
                plant.familyName ?? AppLocalizations.of(context)!.unknownD,
              ),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickMetrics(PlantType plant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _metricItem(Icons.height, "${plant.height ?? '--'}m", AppLocalizations.of(context)!.metricHeight),
        _metricItem(Icons.wb_sunny_outlined, "${plant.expositionTimeSun ?? '--'}h", AppLocalizations.of(context)!.metricSun),
        _metricItem(Icons.calendar_month, plant.plantationSaison ?? "--", AppLocalizations.of(context)!.metricPlanting),
      ],
    );
  }

  Widget _metricItem(IconData icon, String val, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.green[600]),
        const SizedBox(height: 5),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAdviseCard(String? advise) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(advise ?? AppLocalizations.of(context)!.plantNoSpecificAdvise,
                style: TextStyle(color: Colors.green[900], fontSize: 14, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentGrid(PlantType plant) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.5,
      children: [
        _envTile(AppLocalizations.of(context)!.plantExposure, plant.expositionType ?? "--", Icons.wb_sunny),
        _envTile(AppLocalizations.of(context)!.plantGround, plant.groundType ?? "--", Icons.landscape),
      ],
    );
  }

  Widget _envTile(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSeasonBar(PlantType plant) {
    final apiSeasons = [plant.saisonFirst, plant.saisonSecond];

    return Row(
      // On boucle directement sur les valeurs de notre Enum !
      children: PlantSeason.values.map((season) {

        // On compare en utilisant la clé API de l'enum
        bool isActive = apiSeasons.any(
                (element) => element?.toLowerCase() == season.apiKey.toLowerCase()
        );

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              season.getTranslation(context), // 🌟 Appel propre de la traduction
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

enum PlantSeason {
  spring("Printemps"),
  summer("Été"),
  autumn("Automne"),
  winter("Hiver");

  final String apiKey;
  const PlantSeason(this.apiKey);

  String getTranslation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case PlantSeason.spring: return l10n.seasonSpring;
      case PlantSeason.summer: return l10n.seasonSummer;
      case PlantSeason.autumn: return l10n.seasonAutumn;
      case PlantSeason.winter: return l10n.seasonWinter;
    }
  }
}