import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/product.dart';
import '../../../services/shopping_service.dart';
import '../utils/app_theme_tokens.dart';

// Tes imports de composants
import 'package:app/ui/pages/shopping/product_bottom_bar.dart';
import 'package:app/ui/pages/shopping/product_hero.dart';
import 'package:app/ui/pages/shopping/product_spec_list.dart';
import 'package:app/ui/pages/shopping/product_trust_badges.dart';
import 'package:app/ui/pages/widget/tools/cart_badge_widget.dart';

class ShoppingDetailsPage extends StatefulWidget {
  const ShoppingDetailsPage({super.key});

  @override
  State<ShoppingDetailsPage> createState() => _ShoppingDetailsPageState();
}

class _ShoppingDetailsPageState extends State<ShoppingDetailsPage> {
  final ShoppingService _shopService = ShoppingService();
  final PageController _pageController = PageController();
  Product? _product;
  bool _isLoading = true;
  int _currentPage = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_product == null) {
      final dynamic args = ModalRoute.of(context)!.settings.arguments;
      if (args is int) {
        _loadDetails(args);
      }
    }
  }

  void _loadDetails(int id) async {
    final data = await _shopService.fetchProductDetails(id);
    if (mounted) {
      setState(() {
        if (data != null) _product = Product.fromJson(data);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppT.ivory,
      body: Stack(
        children: [
          _isLoading
              ? _buildShimmerEffect()
              : _product == null
              ? const Center(child: Text("Produit introuvable"))
              : _buildContent(),
          _buildNavHeader(),
          if (!_isLoading && _product != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ProductBottomBar(
                inStock: _product!.stock > 0,
                onAdd: () {
                  // Logique d'ajout au panier ici
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        ProductHero(
          product: _product!,
          controller: _pageController,
          currentPage: _currentPage,
          onPageChanged: (i) => setState(() => _currentPage = i),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _product!.brand?.toUpperCase() ?? "GDOME",
                  style: const TextStyle(color: AppT.gold, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 3),
                ),
                const SizedBox(height: 12),
                Text(_product!.title, style: AppT.title),
                const SizedBox(height: 16),
                _buildPriceRow(),
                const SizedBox(height: 32),
                const ProductTrustBadges(),
                const SizedBox(height: 40),
                _buildSectionLabel("L'expérience"),
                Text(
                  _product!.description,
                  style: TextStyle(height: 1.8, color: AppT.ink.withOpacity(0.8), fontSize: 15),
                ),
                if (_product!.technicalDetails.isNotEmpty) ...[
                  const SizedBox(height: 40),
                  _buildSectionLabel("Fiche technique"),
                  ProductSpecList(specs: _product!.technicalDetails),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Text(
      "${_product!.price.toStringAsFixed(2)}€",
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppT.ink, letterSpacing: -1),
    );
  }

  Widget _buildNavHeader() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: AppT.cardShadow,
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppT.ink),
            ),
          ),
          const CartBadgeWidget(),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: AppT.muted),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: MediaQuery.of(context).size.height * 0.45, color: Colors.white),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 10, width: 60, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(height: 30, width: 200, color: Colors.white),
                  const SizedBox(height: 20),
                  Container(height: 40, width: 100, color: Colors.white),
                  const SizedBox(height: 40),
                  Container(height: 100, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}