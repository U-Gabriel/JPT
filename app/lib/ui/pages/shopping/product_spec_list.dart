import 'package:flutter/material.dart';
import '../../utils/app_theme_tokens.dart';

class ProductSpecList extends StatelessWidget {
  final List<String> specs;
  const ProductSpecList({super.key, required this.specs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppT.subtle.withOpacity(0.5)),
      ),
      child: Column(
        children: specs.map((spec) {
          final parts = spec.split(' : ');
          final label = parts[0];
          final value = parts.length > 1 ? parts[1] : "";
          final isLast = spec == specs.last;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: isLast ? null : Border(bottom: BorderSide(color: AppT.subtle.withOpacity(0.3))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: AppT.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppT.ink,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}