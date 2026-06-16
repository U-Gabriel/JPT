import 'package:app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../utils/app_theme_tokens.dart';

class ProductBottomBar extends StatelessWidget {
  final bool inStock;
  final bool isLoading; // Gère l'état de la requête API
  final VoidCallback onAdd;
  final VoidCallback onBuyNow;

  const ProductBottomBar({
    super.key,
    required this.inStock,
    this.isLoading = false,
    required this.onAdd,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        border: Border(top: BorderSide(color: AppT.subtle.withOpacity(0.5))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Row(
        children: [
          // BOUTON AJOUTER AU PANIER (OUTLINED)
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: (inStock && !isLoading) ? onAdd : null,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: inStock ? AppT.ink : AppT.subtle, width: 1.5),
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppT.ink))
                  : const Icon(Icons.add_shopping_cart_outlined, color: AppT.ink),
            ),
          ),
          const SizedBox(width: 12),
          // BOUTON ACHETER MAINTENANT (SOLID)
          Expanded(
            flex: 5,
            child: ElevatedButton(
              onPressed: (inStock && !isLoading) ? onBuyNow : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppT.ink,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppT.subtle,
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: (isLoading)
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(
                inStock ? AppLocalizations.of(context)!.buyNowMaj : AppLocalizations.of(context)!.outOfStockMaj,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}