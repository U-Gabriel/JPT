import 'package:app/l10n/generated/app_localizations.dart';
import 'package:app/ui/pages/widget/plant_card_my_list/plant_item_my_list_widget.dart';
import 'package:app/ui/pages/widget/tools/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/object_profile/object_profile_bloc.dart';
import '../../bloc/object_profile/object_profile_event.dart';
import '../../bloc/object_profile_my_list/object_profile_my_list_bloc.dart';
import '../../bloc/object_profile_my_list/object_profile_my_list_event.dart';
import '../../models/object_profile.dart';
import 'widget/plant_card_favorite/plant_item_widget.dart';

class MyPlantPage extends StatefulWidget {
  const MyPlantPage({Key? key}) : super(key: key);

  @override
  State<MyPlantPage> createState() => _MyPlantPageState();
}

class _MyPlantPageState extends State<MyPlantPage> {
  late ObjectProfileBloc favoriteBloc;
  late ObjectProfileMyListBloc myListBloc;

  // ➔ ÉTAPES 1 : Gestionnaires d'état pour forcer l'affichage du Shimmer uniquement pendant l'appel
  bool _isLoadingFavorite = true;
  bool _isLoadingMyList = true;

  @override
  void initState() {
    super.initState();
    favoriteBloc = context.read<ObjectProfileBloc>();
    myListBloc = context.read<ObjectProfileMyListBloc>();

    // On lance le chargement initial
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_refreshFavorite(), _refreshMyList()]);
  }

  Future<void> _refreshFavorite() async {
    if (!mounted) return;
    setState(() => _isLoadingFavorite = true);

    favoriteBloc.add(LoadProfiles());
    // On attend la première émission du stream pour couper le Shimmer
    await favoriteBloc.profilesStream.firstWhere((_) => true).timeout(
      const Duration(seconds: 4),
      onTimeout: () => [],
    );

    if (mounted) setState(() => _isLoadingFavorite = false);
  }

  Future<void> _refreshMyList() async {
    if (!mounted) return;
    setState(() => _isLoadingMyList = true);

    myListBloc.add(LoadProfilesMyList());
    // On attend la première émission du stream pour couper le Shimmer
    await myListBloc.profilesStream.firstWhere((_) => true).timeout(
      const Duration(seconds: 4),
      onTimeout: () => [],
    );

    if (mounted) setState(() => _isLoadingMyList = false);
  }

  // --- SHIMMER POUR LES FAVORIS (HORIZONTALE) ---
  Widget _buildFavoriteShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => Container(
          width: 280,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  // --- SHIMMER POUR MA LISTE (VERTICALE) ---
  Widget _buildMyListShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(3, (index) => Container(
          height: 110,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([_refreshFavorite(), _refreshMyList()]);
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.myFavorites,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 300,
                  child: StreamBuilder<List<ObjectProfile>>(
                    stream: favoriteBloc.profilesStream,
                    initialData: const [], // ➔ ÉTAPE 2 : On évite le blocage du ConnectionState.waiting
                    builder: (context, snapshot) {
                      // ➔ ÉTAPE 3 : On utilise notre booléen local pour savoir si l'on cherche activement
                      if (_isLoadingFavorite) {
                        return _buildFavoriteShimmer();
                      }

                      final plants = snapshot.data ?? [];
                      if (plants.isEmpty) {
                        return EmptyStateWidget(
                          icon: Icons.favorite_border_rounded,
                          title: AppLocalizations.of(context)!.myFavoritesEmptyTitle,
                          subtitle: AppLocalizations.of(context)!.myFavoritesEmptySubtitle,
                          isHorizontal: true, // Optimise un peu la taille pour le bloc horizontal
                        );
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: plants.length,
                        itemBuilder: (context, index) {
                          return ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 280,
                              maxWidth: 280,
                              minHeight: 400,
                            ),
                            child: PlantItemWidget(plant: plants[index]),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.myList,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                StreamBuilder<List<ObjectProfile>>(
                  stream: myListBloc.profilesStream,
                  initialData: const [], // ➔ ÉTAPE 2 : On évite aussi le blocage ici
                  builder: (context, snapshot) {
                    // ➔ ÉTAPE 3 : Utilisation du second booléen local
                    if (_isLoadingMyList) {
                      return _buildMyListShimmer();
                    }

                    final plants = snapshot.data ?? [];
                    if (plants.isEmpty) {
                      return EmptyStateWidget(
                        icon: Icons.yard_outlined,
                        title: AppLocalizations.of(context)!.myListEmptyTitle,
                        subtitle: AppLocalizations.of(context)!.myListEmptySubtitle,
                      );
                    }

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: plants.length,
                      itemBuilder: (context, index) {
                        return PlantItemMyListWidget(plant: plants[index]);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0, right: 10.0),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add_my_object');
            },
            backgroundColor: const Color(0xFF4CAF50),
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 40, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}