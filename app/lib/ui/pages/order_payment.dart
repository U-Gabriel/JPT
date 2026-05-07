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
    double shipping = (totalProducts > 50) ? 0.00 : 0.50; // On suit ta logique Backend
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

            _buildHeader("ADRESSE DE LIVRAISON"),
            const SizedBox(height: 12),
            _buildAddressPreview(address),

            const SizedBox(height: 24),


            _buildHeader("DÉTAILS DU PAIEMENT"),
            const SizedBox(height: 16),
            _buildPriceDetail("Sous-total", "${totalProducts.toStringAsFixed(2)}€"),
            _buildPriceDetail("Frais de port", shipping == 0 ? "Gratuit" : "${shipping.toStringAsFixed(2)}€"),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider()),
            _buildPriceDetail("Total à régler", "${totalOrder.toStringAsFixed(2)}€", isTotal: true),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(totalOrder, items, address.idAddress ?? 0),
    );
  }

  // --- LOGIQUE DE PAIEMENT ---
  Future<void> _handlePayment(List<CartItem> items, int addressId) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      // Récupération du token depuis le provider
      final token = context.read<AuthProvider>().accessToken!;

      // 1. Appel API pour récupérer le clientSecret
      final paymentData = await _personService.createPaymentIntent(token, items, addressId);

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Paiement validé !"), backgroundColor: Colors.green),
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
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



  Widget _buildPriceDetail(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.w900 : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: FontWeight.w900, color: isTotal ? AppT.gold : AppT.ink)),
      ],
    );
  }

  Widget _buildBottomAction(double total, List<CartItem> items, int addressId) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _isProcessing ? null : () => _handlePayment(items, addressId),
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
}