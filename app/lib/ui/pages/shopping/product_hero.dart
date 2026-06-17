import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart'; // 🔥 Ajouté pour le Shimmer de l'image
import '../../../models/product.dart';
import '../../../services/api_client.dart';
import '../../utils/app_theme_tokens.dart';

class ProductHero extends StatelessWidget {
  final Product product;
  final PageController controller;
  final int currentPage;
  final Function(int) onPageChanged;

  const ProductHero({
    super.key,
    required this.product,
    required this.controller,
    required this.currentPage,
    required this.onPageChanged
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: MediaQuery.of(context).size.height * 0.45,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            product.images.isEmpty
                ? _buildPlaceholder()
                : PageView.builder(
              controller: controller,
              onPageChanged: onPageChanged,
              itemCount: product.images.length,
              itemBuilder: (_, i) => Stack(
                fit: StackFit.expand,
                children: [
                  // 1. LE SHIMMER (Arrière-plan) : S'active directement si la connexion rame
                  Shimmer.fromColors(
                    baseColor: const Color(0xFFF0EEE9),
                    highlightColor: Colors.white,
                    period: const Duration(milliseconds: 1500),
                    child: Container(
                      color: const Color(0xFFF0EEE9),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/logo/favicon_original.svg',
                          height: 40,
                          color: AppT.subtle.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),

                  // 2. L'IMAGE (Premier plan) : S'affiche de manière fulgurante
                  Image.network(
                    ApiClient().getImageUrl(product.images[i]),
                    fit: BoxFit.cover,
                    gaplessPlayback: true, // Évite les sauts blancs au scroll des pages
                    cacheHeight: 600,      // Limite la taille en mémoire (0.45 de l'écran) pour la fluidité

                    // Dès la première frame décodée par le GPU, l'image apparaît en 120ms
                    frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },

                    // Rendu direct sans bloquer l'interface
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return child;
                    },

                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  ),
                ],
              ),
            ),
            if (product.images.length > 1)
              Positioned(
                bottom: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(product.images.length, (i) => _buildDot(i)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int i) => AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    margin: const EdgeInsets.symmetric(horizontal: 3),
    height: 4,
    width: currentPage == i ? 18 : 4,
    decoration: BoxDecoration(
      color: currentPage == i ? AppT.ink : AppT.subtle,
      borderRadius: BorderRadius.circular(2),
    ),
  );

  Widget _buildPlaceholder() => Container(
    color: const Color(0xFFF0EEE9),
    child: Center(
      child: SvgPicture.asset(
        'assets/logo/favicon_original.svg',
        height: 40,
        color: AppT.subtle,
      ),
    ),
  );
}