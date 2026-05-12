import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/cart_item.dart';
import '../../../services/shopping_service.dart';
import '../../../providers/auth_provider.dart';
import '../../app_config.dart';
import '../../providers/cart_provider.dart';
import '../utils/app_theme_tokens.dart';

class CardItemPage extends StatefulWidget {
  const CardItemPage({super.key});

  @override
  State<CardItemPage> createState() => _CardItemPageState();
}

class _CardItemPageState extends State<CardItemPage> {
  final ShoppingService _shopService = ShoppingService();
  List<CartItem> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoad();
  }

  // --- LOGIQUE ---

  // Vérifie si au moins un des objets SÉLECTIONNÉS dépasse le stock
  bool get _hasStockError {
    return _cartItems.any((item) => item.isSelected && item.quantity > item.stock);
  }

  void _checkAuthAndLoad() async {
    final auth = context.read<AuthProvider>();
    if (!mounted) return;

    if (!auth.isAuthenticated || auth.accessToken == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      _loadCart(auth.accessToken!);
    } catch (e) {
      debugPrint("Erreur initialisation panier : $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _loadCart(String token) async {
    try {
      final items = await _shopService.fetchCartList(token);
      if (mounted) {
        setState(() {
          _cartItems = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar("Impossible de charger le panier", Colors.red);
      }
    }
  }

  void _removeItem(CartItem item) async {
    final token = context.read<AuthProvider>().accessToken!;
    bool success = await _shopService.deleteCartItem(token, item.idCartItem);

    if (success && mounted) {
      setState(() => _cartItems.removeWhere((i) => i.idCartItem == item.idCartItem));

      context.read<CartProvider>().loadCartCount(token);

      _showSnackBar("Article supprimé", AppT.ink);
    }
  }

  double get _totalPrice {
    return _cartItems
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + (item.effectivePrice * item.quantity));
  }

  void _showSnackBar(String message, Color bg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: bg, duration: const Duration(seconds: 2)),
    );
  }

  // --- INTERFACE ---

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isAuthenticated) return _buildLoginPlaceholder();

    return Scaffold(
      backgroundColor: AppT.ivory,
      appBar: AppBar(
        title: const Text("Mon Panier", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppT.ink)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? _buildShimmerList()
          : _cartItems.isEmpty
          ? _buildEmptyState()
          : Column(
        children: [
          _buildStockGlobalAlert(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              itemCount: _cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildCartTile(_cartItems[index]),
            ),
          ),
          _buildCheckoutSection(),
        ],
      ),
    );
  }

  Widget _buildStockGlobalAlert() {
    // On affiche l'alerte si un article du panier global a un souci de stock
    bool hasIssue = _cartItems.any((item) => item.quantity > item.stock);
    if (!hasIssue) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.orange.shade50,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _hasStockError
                  ? "Certains articles sélectionnés dépassent le stock disponible. Ajustez les quantités pour continuer."
                  : "Certains articles de votre panier sont presque épuisés.",
              style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartTile(CartItem item) {
    bool isOverStock = item.quantity > item.stock;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isOverStock ? Border.all(color: Colors.red.shade200, width: 1.5) : null,
        boxShadow: AppT.cardShadow,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: item.isSelected,
                  activeColor: AppT.gold,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (val) => setState(() => item.isSelected = val ?? false),
                ),
                _buildProductImage(item.image),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppT.ink),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Text(
                          item.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppT.muted, fontSize: 11),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.discountPrice != null && item.discountPrice! > 0)
                                Text("${item.price.toStringAsFixed(2)}€",
                                    style: const TextStyle(decoration: TextDecoration.lineThrough, color: AppT.muted, fontSize: 10)),
                              Text("${item.effectivePrice.toStringAsFixed(2)}€",
                                  style: const TextStyle(fontWeight: FontWeight.w900, color: AppT.gold, fontSize: 15)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                isOverStock ? "Stock insuffisant (${item.stock})" : "${item.stock} en stock",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isOverStock ? Colors.red : (item.stock < 5 ? Colors.orange : Colors.green),
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildQtyCounter(item),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () => _removeItem(item),
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String? imagePath) {
    return Container(
      width: 65, height: 65,
      decoration: BoxDecoration(color: AppT.ivory, borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: (imagePath != null && imagePath.isNotEmpty)
            ? Image.network("${AppConfig.url}/$imagePath", fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildFallbackIcon())
            : _buildFallbackIcon(),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Center(child: SvgPicture.asset('assets/logo/favicon_green.svg', width: 25));
  }

  Widget _buildQtyCounter(CartItem item) {
    return Container(
      height: 30,
      decoration: BoxDecoration(color: AppT.ivory, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bouton MOINS
          _qtyBtn(Icons.remove, item.quantity > 1 ? () {
            setState(() => item.quantity--); // Maj locale de la page
            context.read<CartProvider>().increment(-1); // Maj du badge global
          } : null),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
          ),

          // Bouton PLUS
          _qtyBtn(Icons.add, () {
            setState(() => item.quantity++); // Maj locale de la page
            context.read<CartProvider>().increment(1); // Maj du badge global
          }),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback? action) {
    return InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 30,
        alignment: Alignment.center,
        child: Icon(icon, size: 14, color: action == null ? Colors.grey.shade400 : AppT.ink),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    final bool canOrder = !_hasStockError && _cartItems.any((i) => i.isSelected);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Text("${_totalPrice.toStringAsFixed(2)}€",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppT.ink)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              // Si canOrder est faux, onPressed est null -> Le bouton devient grisé automatiquement
              onPressed: canOrder ? () {
                final selected = _cartItems.where((i) => i.isSelected).toList();
                Navigator.pushNamed(context, '/order_adress_page', arguments: selected);
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppT.ink,
                disabledBackgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                  _hasStockError ? "STOCK INSUFFISANT" : "VALIDER LA COMMANDE",
                  style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("Votre panier est vide", style: TextStyle(fontWeight: FontWeight.bold, color: AppT.muted)),
        ],
      ),
    );
  }

  Widget _buildLoginPlaceholder() {
    return Scaffold(
      backgroundColor: AppT.ivory,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: AppT.gold),
            const SizedBox(height: 24),
            const Text("Connectez-vous", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            const Text("Retrouvez votre panier et finalisez vos achats en vous connectant.",
                textAlign: TextAlign.center, style: TextStyle(color: AppT.muted)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppT.ink,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("SE CONNECTER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      itemCount: 4, // Nombre d'items fantômes à afficher
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 100, // Taille approximative de tes tuiles
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const SizedBox(width: 48), // Place du checkbox
              Container(
                width: 65, height: 65,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 120, height: 14, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 180, height: 10, color: Colors.white),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 50, height: 15, color: Colors.white),
                        Container(width: 80, height: 25, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10))),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}