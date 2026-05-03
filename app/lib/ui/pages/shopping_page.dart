import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../../../models/product.dart';
import '../../../services/shopping_service.dart';
import '../../../services/tag_service.dart';
import '../../../providers/auth_provider.dart';
import '../utils/app_theme_tokens.dart';
import 'package:app/ui/pages/widget/tools/cart_badge_widget.dart';
import 'package:app/ui/pages/widget/shopping/ProductCard.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final ShoppingService _shopService = ShoppingService();
  final TagService _tagService = TagService();
  final TextEditingController _searchController = TextEditingController();

  List<Product> _catalog = []; // Typage en Product
  List<dynamic> _tags = [];
  bool _isLoading = true;
  int? _selectedTagId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.accessToken ?? "";

    final fetchedTags = await _tagService.fetchTags(token);
    if (mounted) {
      setState(() => _tags = fetchedTags);
      _refreshCatalog();
    }
  }

  void _refreshCatalog() async {
    setState(() => _isLoading = true);
    final items = await _shopService.fetchCatalog(
      idTag: _selectedTagId,
      titleSearch: _searchController.text,
    );

    if (mounted) {
      setState(() {
        // Conversion de dynamic vers le modèle Product
        _catalog = items.map((json) => Product.fromJson(json)).toList();
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
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              _buildFilters(),
              _isLoading ? _buildShimmerGrid() : _buildProductGrid(),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          Positioned(
            bottom: 30,
            right: 24,
            child: const CartBadgeWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppT.ivory,
      elevation: 0,
      toolbarHeight: 70,
      centerTitle: true,
      title: SvgPicture.asset('assets/logo/logo_complet.svg', height: 35),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: TextField(
            controller: _searchController,
            onSubmitted: (v) => _refreshCatalog(),
            decoration: InputDecoration(
              hintText: "Rechercher un modèle...",
              prefixIcon: const Icon(Icons.search_rounded, color: AppT.ink),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppT.subtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppT.subtle),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _tags.length + 1,
          itemBuilder: (context, index) {
            final isFirst = index == 0;
            final label = isFirst ? "Tous" : _tags[index - 1]['title'];
            final id = isFirst ? null : _tags[index - 1]['id_tag'];
            final isSelected = _selectedTagId == id;

            return GestureDetector(
              onTap: () {
                setState(() => _selectedTagId = id);
                _refreshCatalog();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppT.ink : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? AppT.ink : AppT.subtle),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppT.ink,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_catalog.isEmpty) {
      return const SliverFillRemaining(child: Center(child: Text("Aucun produit disponible")));
    }
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(product: _catalog[index]),
          childCount: _catalog.length,
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 380,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            ),
          ),
          childCount: 2,
        ),
      ),
    );
  }
}