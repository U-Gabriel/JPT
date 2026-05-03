import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/product.dart';
import '../../utils/app_theme_tokens.dart';

class ProductHero extends StatelessWidget {
  final Product product;
  final PageController controller;
  final int currentPage;
  final Function(int) onPageChanged;

  const ProductHero({super.key, required this.product, required this.controller, required this.currentPage, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.45,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            product.images.isEmpty ? _buildPlaceholder() : PageView.builder(
              controller: controller,
              onPageChanged: onPageChanged,
              itemCount: product.images.length,
              itemBuilder: (_, i) => Image.network(
                product.images[i],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
              ),
            ),
            if (product.images.length > 1)
              Positioned(bottom: 20, child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(product.images.length, (i) => _buildDot(i)))),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int i) => AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    margin: const EdgeInsets.symmetric(horizontal: 3),
    height: 4, width: currentPage == i ? 18 : 4,
    decoration: BoxDecoration(color: currentPage == i ? AppT.ink : AppT.subtle, borderRadius: BorderRadius.circular(2)),
  );

  Widget _buildPlaceholder() => Container(
    color: const Color(0xFFF0EEE9),
    child: Center(child: SvgPicture.asset('assets/logo/favicon_original.svg', height: 40, color: AppT.subtle)),
  );
}