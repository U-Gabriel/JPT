import 'package:app/ui/pages/widget/tools/step_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import '../../../models/cart_item.dart';
import '../../../models/address_person.dart';
import '../../../services/person_service.dart';
import '../../../providers/auth_provider.dart';
import '../utils/app_theme_tokens.dart';

class OrderPaymentPage extends StatefulWidget {
  const OrderPaymentPage({super.key});

  @override
  State<OrderPaymentPage> createState() => _OrderPaymentPageState();
}

class _OrderPaymentPageState extends State<OrderPaymentPage> {
  final PersonService _personService = PersonService();
  String _selectedMethod = "card"; // card, paypal
  bool _isProcessing = false; // Pour éviter les doubles clics

  @override
  Widget build(BuildContext context) {
    // 1. Récupération des données passées par la page précédente
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final AddressPerson address = args['address'];
    final List<CartItem> items = args['items'];

    // 2. Calcul des prix locaux (pour affichage seulement, l'API recalculera tout)
    double totalProducts = items.fold(0, (sum, item) => sum + (item.effectivePrice * item.quantity));
    double shipping = (totalProducts > 50) ? 0.00 : 8.90; // On suit ta logique Backend
    double totalOrder = totalProducts + shipping;

    return Scaffold(
      backgroundColor: AppT.ivory,
      appBar: AppBar(
        title: const Text("Récapitulatif", style: TextStyle(color: AppT.ink, fontWeight: FontWeight.w900, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppT.ink, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepProgressBar(percent: 0.75),
            const SizedBox(height: 24),

            // --- SECTION ADRESSE ---
            _buildHeader("LIVRAISON À"),
            const SizedBox(height: 12),
            _buildAddressPreview(address),

            const SizedBox(height: 32),

            _buildHeader("VOTRE COMMANDE"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppT.cardShadow,
              ),
              child: Column(
                children: [
                  // 1. Liste minimaliste des articles (plus petite, style "reçu")
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text("${item.quantity}x", style: TextStyle(color: AppT.gold, fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(item.title, style: const TextStyle(fontSize: 12, color: AppT.muted))),
                            Text("${(item.effectivePrice * item.quantity).toStringAsFixed(2)}€", style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),

                  // 2. La ligne de séparation en pointillés (très pro pour un paiement)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: List.generate(30, (index) => Expanded(
                        child: Container(
                          color: index % 2 == 0 ? Colors.transparent : AppT.ivory,
                          height: 2,
                        ),
                      )),
                    ),
                  ),

                  // 3. Les calculs financiers
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildPriceRow("Sous-total", "${totalProducts.toStringAsFixed(2)}€"),
                        const SizedBox(height: 8),
                        _buildPriceRow("Livraison", shipping == 0 ? "Offerte" : "${shipping.toStringAsFixed(2)}€",
                            color: shipping == 0 ? Colors.green : AppT.ink),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("TOTAL", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                            Text("${totalOrder.toStringAsFixed(2)}€",
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: AppT.gold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 120), // Espace pour le bouton du bas
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(totalOrder, items, address),
    );
  }

  // --- LOGIQUE DE PAIEMENT ---
  Future<void> _handlePayment(List<CartItem> items, AddressPerson address, double totalOrder) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      // Récupération du token depuis le provider
      final token = context.read<AuthProvider>().accessToken!;

      // 1. Appel API pour récupérer le clientSecret
      final paymentData = await _personService.createPaymentIntent(token, items, address.idAddress ?? 0);

      if (paymentData == null) throw Exception("Impossible d'initialiser le paiement.");

      // 2. Init Stripe Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentData['clientSecret'],
          merchantDisplayName: 'JackPote App',
          style: ThemeMode.light,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(primary: AppT.gold),
          ),
        ),
      );

      // 3. Présentation du formulaire
      await Stripe.instance.presentPaymentSheet();

      // 4. Succès
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/order_validation_page',
              (route) => false,
          arguments: {
            'items': items,
            'address': address,
            'total': totalOrder,
          },
        );
      }

    } catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Paiement non finalisé : ${e.error.localizedMessage}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // --- WIDGETS DE COMPOSANTS ---

  // Widget pour chaque article du panier
  Widget _buildCartItemRow(CartItem item) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          // Badge quantité stylisé
          Container(
            height: 40, width: 40,
            decoration: BoxDecoration(color: AppT.ivory, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text("x${item.quantity}", style: const TextStyle(fontWeight: FontWeight.w900, color: AppT.gold)),
            ),
          ),
          const SizedBox(width: 16),
          // Titre de l'article
          Expanded(
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          // Prix unitaire
          Text(
            "${(item.effectivePrice * item.quantity).toStringAsFixed(2)}€",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

// Version améliorée de ton _buildPriceDetail
  Widget _buildPriceDetail(String label, String value, {bool isTotal = false, bool isMuted = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w500,
            color: isMuted ? AppT.muted : AppT.ink,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 14,
            fontWeight: FontWeight.w900,
            color: valueColor ?? (isTotal ? AppT.gold : AppT.ink),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1, color: AppT.ink));
  }

  Widget _buildAddressPreview(AddressPerson addr) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: AppT.cardShadow),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: AppT.ivory, child: Icon(Icons.location_on, color: AppT.gold, size: 20)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(addr.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text("${addr.addressLine1}, ${addr.city}", style: const TextStyle(color: AppT.muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(double total, List<CartItem> items, AddressPerson address) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _isProcessing ? null : () => _handlePayment(items, address, total),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppT.ink, foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: _isProcessing
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text("CONFIRMER ET PAYER ${total.toStringAsFixed(2)}€", style: const TextStyle(fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
  Widget _buildPriceRow(String label, String value, {Color color = AppT.ink, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppT.muted, // On met le libellé un peu plus discret
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900, // On garde le chiffre bien lisible
            color: color,
          ),
        ),
      ],
    );
  }
}