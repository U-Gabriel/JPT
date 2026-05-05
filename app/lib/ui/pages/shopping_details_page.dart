import 'package:app/ui/pages/widget/popup/auth_required_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/product.dart';
import '../../../services/shopping_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../utils/app_theme_tokens.dart';

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
  bool _isSubmitting = false; // Pour l'état de chargement des boutons
  int _currentPage = 0;
  int _selectedQty = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_product == null) {
      final dynamic args = ModalRoute.of(context)!.settings.arguments;
      if (args is int) _loadDetails(args);
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

  void _updateQty(int delta) {
    if (_product == null) return;
    setState(() {
      _selectedQty = (_selectedQty + delta).clamp(1, _product!.stock > 0 ? _product!.stock : 1);
    });
    HapticFeedback.lightImpact();
  }

  void _handleAction({required bool buyNow}) async {
    if (_isSubmitting) return;

    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated) {
      AuthRequiredDialog.show(context);
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await _shopService.addToCart(
      idObject: _product!.id,
      quantity: _selectedQty,
      token: auth.accessToken!,
    );

    if (mounted) setState(() => _isSubmitting = false);

    if (success && mounted) {
      HapticFeedback.mediumImpact();

      context.read<CartProvider>().increment(_selectedQty);

      if (buyNow) {
        Navigator.pushNamed(context, '/card_item_page');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: AppT.ink,
                content: Text("$_selectedQty article(s) ajouté(s) au panier !"),
                behavior: SnackBarBehavior.floating
            )
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'ajout. Réessayez."), backgroundColor: Colors.redAccent)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppT.ivory,
      body: Stack(
        children: [
          _isLoading ? _buildShimmerEffect() : _product == null ? _error() : _buildContent(),
          _buildNavHeader(),
          if (!_isLoading && _product != null)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: ProductBottomBar(
                inStock: _product!.stock > 0,
                isLoading: _isSubmitting,
                onAdd: () => _handleAction(buyNow: false),
                onBuyNow: () => _handleAction(buyNow: true),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavHeader() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20, right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppT.cardShadow),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppT.ink),
            ),
          ),
          const CartBadgeWidget(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final p = _product!;
    final double unitPrice = p.discountPrice != null && p.discountPrice! > 0 ? p.discountPrice! : p.price;
    final double totalPrice = unitPrice * _selectedQty;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        ProductHero(product: p, controller: _pageController, currentPage: _currentPage, onPageChanged: (i) => setState(() => _currentPage = i)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.brand?.toUpperCase() ?? "GDOME", style: const TextStyle(color: AppT.gold, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 3)),
                const SizedBox(height: 8),
                Text(p.title, style: AppT.title),
                const SizedBox(height: 24),
                _buildPriceAndQtySection(p, unitPrice, totalPrice),
                const SizedBox(height: 32),
                const ProductTrustBadges(),
                const SizedBox(height: 40),
                _buildSectionLabel("L'expérience"),
                Text(p.description, style: TextStyle(height: 1.8, color: AppT.ink.withOpacity(0.8), fontSize: 15)),
                if (p.technicalDetails.isNotEmpty) ...[
                  const SizedBox(height: 40),
                  _buildSectionLabel("Fiche technique"),
                  ProductSpecList(specs: p.technicalDetails),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndQtySection(Product p, double unitPrice, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppT.subtle),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (p.discountPrice != null && p.discountPrice! > 0)
                    Text("${(p.price * _selectedQty).toStringAsFixed(2)}€", style: const TextStyle(decoration: TextDecoration.lineThrough, color: AppT.muted, fontSize: 14)),
                  Text("${total.toStringAsFixed(2)}€", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppT.ink)),
                ],
              ),
              _buildQtySelector(p.stock),
            ],
          ),
          const Divider(height: 32, color: AppT.subtle),
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, size: 16, color: p.stock > 0 ? Colors.green : Colors.red),
              const SizedBox(width: 8),
              Text(
                p.stock > 0 ? "En stock (${p.stock} unités)" : "Actuellement épuisé",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: p.stock > 0 ? Colors.green : Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtySelector(int maxStock) {
    return Container(
      decoration: BoxDecoration(color: AppT.ivory, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          IconButton(onPressed: _selectedQty > 1 ? () => _updateQty(-1) : null, icon: const Icon(Icons.remove, size: 18)),
          Text("$_selectedQty", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          IconButton(onPressed: _selectedQty < maxStock ? () => _updateQty(1) : null, icon: const Icon(Icons.add, size: 18)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: AppT.muted)),
    );
  }

  Widget _error() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppT.muted.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text("Produit introuvable", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppT.ink)),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("RETOURNER AU CATALOGUE", style: TextStyle(color: AppT.gold, fontWeight: FontWeight.bold)),
          ),
        ],
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
                  Container(height: 15, width: 100, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(height: 30, width: 250, color: Colors.white),
                  const SizedBox(height: 30),
                  Container(height: 120, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}