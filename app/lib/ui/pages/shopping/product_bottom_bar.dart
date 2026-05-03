import 'package:flutter/material.dart';
import '../../utils/app_theme_tokens.dart';

class ProductBottomBar extends StatelessWidget {
  final bool inStock;
  final VoidCallback onAdd;

  const ProductBottomBar({super.key, required this.inStock, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(color: AppT.ivory, border: Border(top: BorderSide(color: AppT.subtle))),
      child: ElevatedButton(
        onPressed: inStock ? onAdd : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppT.ink, foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text(inStock ? "AJOUTER AU PANIER" : "ÉPUISÉ", style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
      ),
    );
  }
}