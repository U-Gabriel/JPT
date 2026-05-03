import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../models/product.dart';
import '../../../utils/app_theme_tokens.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({required this.product});

  @override
  State<ProductCard> createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  int _currentImg = 0;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final bool hasPromo = p.discountPrice != null && p.discountPrice! > 0;
    final bool isOutOfStock = p.stock <= 0;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/shopping_details_page', arguments: p.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppT.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE CAROUSEL
            SizedBox(
              height: 280,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: p.images.isEmpty
                        ? _buildPlaceholder()
                        : PageView.builder(
                      onPageChanged: (i) => setState(() => _currentImg = i),
                      itemCount: p.images.length,
                      itemBuilder: (context, i) => Image.network(
                        p.images[i],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(),
                      ),
                    ),
                  ),
                  // Bulles de pagination (Indicateur)
                  if (p.images.length > 1)
                    Positioned(
                      bottom: 15,
                      left: 0, right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(p.images.length, (i) => _buildDot(i)),
                      ),
                    ),
                  // Badge Promo
                  if (hasPromo)
                    Positioned(
                      top: 15, left: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: AppT.gold, borderRadius: BorderRadius.circular(8)),
                        child: const Text("PROMO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10)),
                      ),
                    ),
                ],
              ),
            ),

            // DETAILS
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppT.ink)),
                            const SizedBox(height: 4),
                            Text(p.brand ?? "GDOME", style: const TextStyle(color: AppT.gold, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 1)),
                          ],
                        ),
                      ),
                      _buildPrice(p),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStockInfo(isOutOfStock, p.stock),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 4,
      width: _currentImg == index ? 16 : 4,
      decoration: BoxDecoration(
        color: _currentImg == index ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildPrice(Product p) {
    final hasPromo = p.discountPrice != null && p.discountPrice! > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (hasPromo)
          Text("${p.price.toStringAsFixed(2)}€", style: const TextStyle(decoration: TextDecoration.lineThrough, color: AppT.muted, fontSize: 12)),
        Text(
          "${(hasPromo ? p.discountPrice! : p.price).toStringAsFixed(2)}€",
          style: const TextStyle(color: AppT.ink, fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildStockInfo(bool isOutOfStock, int stock) {
    return Row(
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: isOutOfStock ? Colors.red : Colors.green, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          isOutOfStock ? "Indisponible" : "En stock ($stock)",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isOutOfStock ? Colors.red : Colors.green[700]),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF0EEE9),
      child: Center(child: SvgPicture.asset('assets/logo/favicon_original.svg', height: 40, color: AppT.subtle)),
    );
  }
}