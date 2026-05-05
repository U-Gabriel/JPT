import 'package:app/ui/pages/widget/popup/auth_required_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../models/cart_item.dart';
import '../../../services/shopping_service.dart';
import '../../../providers/auth_provider.dart';
import '../../app_config.dart';
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

  void _checkAuthAndLoad() async {
    // 1. On récupère le provider sans écouter (read)
    final auth = context.read<AuthProvider>();

    // 2. Vérification de sécurité sur le montage du widget
    if (!mounted) return;

    // 3. Gestion de l'absence d'authentification
    if (!auth.isAuthenticated || auth.accessToken == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // 4. Appel sécurisé du chargement
    try {
      // On passe directement le token récupéré de manière sûre
      _loadCart(auth.accessToken!);
    } catch (e) {
      debugPrint("Erreur lors de l'initialisation du panier : $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // On ajoute le paramètre String token
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Impossible de charger le panier")),
        );
      }
    }
  }

  // Suppression réelle via l'API
  void _removeItem(CartItem item) async {
    final token = context.read<AuthProvider>().accessToken!;

    // On lance la requête de suppression
    bool success = await _shopService.deleteCartItem(token, item.idCartItem);

    if (success && mounted) {
      setState(() {
        _cartItems.removeWhere((i) => i.idCartItem == item.idCartItem);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Article supprimé du panier"), backgroundColor: Colors.green),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la suppression"), backgroundColor: Colors.red),
      );
    }
  }

  double get _totalPrice {
    return _cartItems
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + (item.effectivePrice * item.quantity));
  }

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
          ? const Center(child: CircularProgressIndicator(color: AppT.gold))
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
    bool hasIssue = _cartItems.any((item) => item.isStockIssue);
    if (!hasIssue) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.orange.shade50,
      padding: const EdgeInsets.all(12),
      child: const Row(
        children: [
          Icon(Icons.bolt, color: Colors.orange, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Stocks limités ! Finalisez vite votre commande.",
              style: TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartTile(CartItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppT.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppT.ink),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Text(
                            item.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppT.muted, fontSize: 11),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
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
                            _buildQtyCounter(item),
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
                onPressed: () => _removeItem(item), // Utilise maintenant l'objet item
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imagePath) {
    return Container(
      width: 60, height: 60, // Taille réduite pour plus de compatibilité
      decoration: BoxDecoration(color: AppT.ivory, borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: (imagePath != null && imagePath.isNotEmpty)
            ? Image.network(
          "${AppConfig.url}/$imagePath",
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
        )
            : _buildFallbackIcon(),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Center(
      child: SvgPicture.asset(
        'assets/logo/favicon_green.svg',
        width: 25,
        height: 25,
        placeholderBuilder: (context) => const Icon(Icons.shopping_bag_outlined, size: 20),
      ),
    );
  }

  Widget _buildQtyCounter(CartItem item) {
    return Container(
      height: 28,
      decoration: BoxDecoration(color: AppT.ivory, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtyBtn(Icons.remove, item.quantity > 1 ? () => setState(() => item.quantity--) : null),
          Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
          _qtyBtn(Icons.add, () => setState(() => item.quantity++)),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback? action) {
    return IconButton(
      onPressed: action,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28),
      icon: Icon(icon, size: 12, color: action == null ? AppT.muted : AppT.ink),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              onPressed: () {
                final selected = _cartItems.where((i) => i.isSelected).toList();
                for (var i in selected) print("ID: ${i.id} | Qty: ${i.quantity}");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppT.ink,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("VALIDER", style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text("Panier vide", style: TextStyle(fontWeight: FontWeight.bold)));
  }

  Widget _buildLoginPlaceholder() {
    return Scaffold(
      backgroundColor: AppT.ivory,
      // On ajoute une AppBar minimaliste juste pour le bouton retour
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppT.ink, size: 20),
          onPressed: () => Navigator.maybePop(context), // Retourne à la page précédente
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle_outlined, size: 80, color: AppT.gold),
            const SizedBox(height: 24),
            const Text(
                "Panier réservé aux membres",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppT.ink)
            ),
            const SizedBox(height: 12),
            Text(
                "Connectez-vous pour retrouver vos articles et finaliser vos achats en toute sécurité.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppT.muted, fontSize: 14)
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppT.ink,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text("SE CONNECTER", style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
            ),
            const SizedBox(height: 16),
            // Optionnel : un bouton texte pour revenir à l'accueil si le bouton du haut est trop discret
            TextButton(
              onPressed: () => Navigator.maybePop(context),
              child: Text("Continuer mes achats", style: TextStyle(color: AppT.muted, fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }
}