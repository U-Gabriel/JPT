import 'package:app/ui/profile/widget/catalog_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/object_profile_service.dart';
import '../../../models/category_catalog.dart';

class MyObjectProfilePage extends StatefulWidget {
  const MyObjectProfilePage({super.key});

  @override
  State<MyObjectProfilePage> createState() => _MyObjectProfilePageState();
}

class _MyObjectProfilePageState extends State<MyObjectProfilePage> {
  final ObjectProfileService _profileService = ObjectProfileService();
  Future<List<CategoryCatalog>>? _catalogFuture;

  @override
  void initState() {
    super.initState();
    final token = context.read<AuthProvider>().accessToken;
    if (token != null) {
      _catalogFuture = _profileService.fetchCategoryCatalog(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Mes Objets Connectés", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: FutureBuilder<List<CategoryCatalog>>(
        future: _catalogFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoader();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Impossible de charger vos catégories."));
          }

          final categories = snapshot.data!;

          if (categories.isEmpty) {
            return const Center(child: Text("Aucun objet enregistré pour le moment."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];

              if (cat.objects.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre de la catégorie stylisé
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
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${cat.objects.length}",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Liste horizontale des objets de cette catégorie
                  SizedBox(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: cat.objects.length,
                      itemBuilder: (context, objIndex) {
                        return CatalogItemWidget(item: cat.objects[objIndex]);
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