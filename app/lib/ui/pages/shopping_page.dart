import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../../services/shopping_service.dart';
import '../../../services/tag_service.dart';
import '../../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final ShoppingService _shopService = ShoppingService();
  final TagService _tagService = TagService();

  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _catalog = [];
  List<dynamic> _tags = [];
  bool _isLoading = true;

  int? _selectedTagId;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    final token = context.read<AuthProvider>().accessToken ?? "";
    final fetchedTags = await _tagService.fetchTags(token);
    setState(() => _tags = fetchedTags);
    _refreshCatalog();
  }



  void _refreshCatalog() async {
    setState(() => _isLoading = true);
    final items = await _shopService.fetchCatalog(
      idTag: _selectedTagId,
      titleSearch: _searchController.text,
    );
    setState(() {
      _catalog = items;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              _buildFilters(),
              _isLoading ? _buildShimmerGrid() : _buildProductGrid(),
            ],
          ),
          _buildFloatingCart(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: SvgPicture.asset('assets/logo/logo_complet.svg', height: 40),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: _searchController,
            onChanged: (v) {
              _refreshCatalog();
            },
            decoration: InputDecoration(
              hintText: "Rechercher un équipement...",
              prefixIcon: const Icon(Icons.search, color: Colors.green),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: _tags.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) return _buildTagChip("Tous", null);
            final tag = _tags[index - 1];
            return _buildTagChip(tag['title'], tag['id_tag']);
          },
        ),
      ),
    );
  }

  Widget _buildTagChip(String label, int? id) {
    final isSelected = _selectedTagId == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {
          setState(() {
            if (isSelected) {
              _selectedTagId = null;
            } else {
              _selectedTagId = id;
            }
          });
          _refreshCatalog();
        },
        selectedColor: Colors.green,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_catalog.isEmpty) {
      return const SliverFillRemaining(child: Center(child: Text("Aucun produit trouvé")));
    }
    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 20,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => _ProductCard(product: _catalog[index]),
          childCount: _catalog.length,
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 300,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
            ),
          ),
          childCount: 3,
        ),
      ),
    );
  }

  Widget _buildFloatingCart() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/card_item_page'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2D3E50),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)],
          ),
          child: Row(
            children: [
              const Icon(Icons.shopping_basket_outlined, color: Colors.white, size: 28),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                child: const Text("0", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final dynamic product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final assets = product['assets'] as List<dynamic>? ?? [];

    // Parsing des prix avec sécurité sur le 0
    final rawPrice = double.tryParse(product['price']?.toString() ?? "");
    final rawDiscount = double.tryParse(product['discount_price']?.toString() ?? "");

    // Si un prix est à 0, on le traite comme null (invalide)
    final double? price = (rawPrice != null && rawPrice > 0) ? rawPrice : null;
    final double? discountPrice = (rawDiscount != null && rawDiscount > 0) ? rawDiscount : null;

    final int stock = product['stock_quantity'] ?? 0;
    final bool isOutOfStock = stock <= 0;
    final bool hasNoPriceData = (price == null && discountPrice == null);
    final bool isOnSale = discountPrice != null && price != null;

    // Calcul du pourcentage
    int? discountPercentage;
    if (isOnSale) {
      discountPercentage = (((price - discountPrice) / price) * 100).round();
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/shopping_details_page', arguments: product['id_object']),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    child: assets.isEmpty
                        ? _buildPlaceholder()
                        : PageView.builder(
                      itemCount: assets.length,
                      itemBuilder: (context, i) {
                        final imgUrl = "http://51.77.141.175:3000/${assets[i]['file_path']}";
                        return Image.network(
                          imgUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => _buildPlaceholder(),
                        );
                      },
                    ),
                  ),
                  // Badge de pourcentage de réduction
                  if (isOnSale)
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]
                        ),
                        child: Text(
                          "-$discountPercentage%",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
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
                            Text(product['title'] ?? "Sans nom",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(product['brand'] ?? "GDOME Original",
                                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                          ],
                        ),
                      ),
                      _buildPriceTag(price, discountPrice, hasNoPriceData),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 14, color: isOutOfStock ? Colors.red : Colors.blueGrey),
                      const SizedBox(width: 5),
                      Text(
                        isOutOfStock ? "Rupture de stock" : "$stock articles restants",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isOutOfStock ? Colors.red : Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTag(double? price, double? discountPrice, bool hasNoPrice) {
    if (hasNoPrice) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(12)),
        child: const Text("SUR DEVIS", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (discountPrice != null && price != null)
          Text("${price.toStringAsFixed(2)}€",
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
                fontSize: 12,
              )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: discountPrice != null ? Colors.red[50] : Colors.green[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "${(discountPrice ?? price ?? 0).toStringAsFixed(2)}€",
            style: TextStyle(
              color: discountPrice != null ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/logo/favicon_original.svg', height: 40, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text("Image non disponible", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ],
        ),
      ),
    );
  }


}