import 'package:flutter/material.dart';
import '../../../models/cart_item.dart';
import '../../../models/address_person.dart';
import '../utils/app_theme_tokens.dart';

class OrderValidationPage extends StatelessWidget {
  const OrderValidationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupération des arguments
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<CartItem> items = args['items'];
    final AddressPerson address = args['address'];
    final double total = args['total'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // --- ANIMATION / ICON DE SUCCÈS ---
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.greenAccent,
                      child: Icon(Icons.check_rounded, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Félicitations !",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppT.ink),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Votre commande a été validée avec succès et est en cours de préparation.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppT.muted, fontSize: 14),
                    ),

                    const SizedBox(height: 40),
                    const Divider(),

                    // --- RÉCAPITULATIF DES ARTICLES ---
                    _buildSectionTitle("VOTRE COMMANDE"),
                    const SizedBox(height: 16),
                    ...items.map((item) => _buildItemTile(item)).toList(),

                    const SizedBox(height: 24),
                    const Divider(),

                    // --- ADRESSE DE LIVRAISON ---
                    _buildSectionTitle("ADRESSE DE LIVRAISON"),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.local_shipping_outlined,
                      title: address.title,
                      subtitle: "${address.addressLine1}, ${address.city} ${address.postalCode}",
                    ),

                    const SizedBox(height: 24),

                    // --- RÉCAPITULATIF FINANCIER ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppT.ivory,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Montant total réglé", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${total.toStringAsFixed(2)}€",
                              style: const TextStyle(fontWeight: FontWeight.w900, color: AppT.gold, fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // --- ACTIONS ---
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppT.ink,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: const Text("RETOURNER À L'ACCUEIL", style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/my_orders'), // Optionnel
                    child: const Text("Suivre mes commandes", style: TextStyle(color: AppT.gold, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.2, color: AppT.ink)),
    );
  }

  Widget _buildItemTile(CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppT.ivory, borderRadius: BorderRadius.circular(8)),
            child: Text("x${item.quantity}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
          ),
          Text("${(item.effectivePrice * item.quantity).toStringAsFixed(2)}€", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String subtitle}) {
    return Row(
      children: [
        Icon(icon, color: AppT.gold, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle, style: const TextStyle(color: AppT.muted, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}