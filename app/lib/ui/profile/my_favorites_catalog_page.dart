import 'package:app/l10n/generated/app_localizations.dart';
import 'package:app/ui/profile/widget/catalog_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/object_profile_service.dart';
import '../../../models/category_catalog.dart';

class MyFavoritesCatalogPage extends StatefulWidget {
  const MyFavoritesCatalogPage({super.key});

  @override
  State<MyFavoritesCatalogPage> createState() => _MyFavoritesCatalogPageState();
}

class _MyFavoritesCatalogPageState extends State<MyFavoritesCatalogPage> {
  final ObjectProfileService _profileService = ObjectProfileService();
  Future<List<CategoryCatalog>>? _favoritesFuture;

  @override
  void initState() {
    super.initState();
    final token = context.read<AuthProvider>().accessToken;
    if (token != null) {
      _favoritesFuture = _profileService.fetchCategoryFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myFavoritesMajD, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: FutureBuilder<List<CategoryCatalog>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoader();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text(AppLocalizations.of(context)!.failureChargeFavorites));
          }

          final categories = snapshot.data!;

          // Filtre pour ne garder que les catégories qui ont vraiment des objets favoris
          final cleanCategories = categories.where((cat) => cat.objects.isNotEmpty).toList();

          if (cleanCategories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_border_rounded, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.noFavoritesForMoment, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: cleanCategories.length,
            itemBuilder: (context, index) {
              final cat = cleanCategories[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre de la catégorie
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cat.categoryTitle.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.blueGrey,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${cat.objects.length}",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.pink.shade400),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Liste horizontale de favoris (Réutilise le CatalogItemWidget existant)
                  SizedBox(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: cat.objects.length,
                      itemBuilder: (context, objIndex) {
                        return CatalogItemWidget(
                          item: cat.objects[objIndex],
                          onTapRefresh: () {
                            // ✨ Magie : Quand l'utilisateur fait "retour", cette fonction se déclenche !
                            setState(() {
                              final token = context.read<AuthProvider>().accessToken;
                              if (token != null) {
                                // On relance la requête API pour rafraîchir instantanément l'écran
                                _favoritesFuture = _profileService.fetchCategoryFavorites();
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 2,
        itemBuilder: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 20, width: 100, color: Colors.white, margin: const EdgeInsets.symmetric(vertical: 12)),
            Row(
              children: List.generate(2, (_) => Container(
                height: 150, width: 140,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              )),
            )
          ],
        ),
      ),
    );
  }
}