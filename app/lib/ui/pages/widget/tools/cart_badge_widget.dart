import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth_provider.dart';
import '../../../../providers/cart_provider.dart'; // Import de ton nouveau provider
import '../../../../services/shopping_service.dart';

class CartBadgeWidget extends StatefulWidget {
  const CartBadgeWidget({super.key});

  @override
  State<CartBadgeWidget> createState() => _CartBadgeWidgetState();
}

class _CartBadgeWidgetState extends State<CartBadgeWidget> {
  final ShoppingService _shopService = ShoppingService();
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    // On charge les données depuis l'API au démarrage
    _loadInitialCartCount();
  }

  void _loadInitialCartCount() async {
    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated) {
      final count = await _shopService.getCartCount();
      if (mounted) {
        // On met à jour le Provider avec la valeur réelle de l'API
        context.read<CartProvider>().updateCount(count);
        setState(() {
          _isFirstLoad = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ICI : On écoute le provider.
    // Dès que tu feras cartProvider.increment() ailleurs, ce widget se reconstruira.
    final cartCount = context.watch<CartProvider>().cartCount;

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/card_item_page'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D3E50),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_basket_outlined, color: Colors.white, size: 28),
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF2D3E50), width: 2),
                  ),
                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Center(
                    child: Text(
                      cartCount > 99 ? "99+" : "$cartCount",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}