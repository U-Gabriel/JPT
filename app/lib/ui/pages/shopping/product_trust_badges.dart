import 'package:flutter/material.dart';
import '../../utils/app_theme_tokens.dart';

class ProductTrustBadges extends StatelessWidget {
  const ProductTrustBadges({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = [
      (Icons.security_outlined, "Paiement\nSécurisé"),
      (Icons.biotech_outlined, "Conception\Haute Précision"),
      (Icons.verified_outlined, "Satisfaction\nAssurée"),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppT.subtle),
        boxShadow: AppT.cardShadow,
      ),
      child: Row(
        children: badges.map((b) => Expanded(
          child: Column(
            children: [
              Icon(b.$1, size: 22, color: AppT.ink),
              const SizedBox(height: 8),
              Text(
                b.$2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppT.muted,
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}