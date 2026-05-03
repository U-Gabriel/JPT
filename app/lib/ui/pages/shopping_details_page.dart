import 'package:flutter/material.dart';

class ShoppingDetailsPage extends StatelessWidget {
  const ShoppingDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupération de l'ID passé en argument
    final int? idObject = ModalRoute.of(context)?.settings.arguments as int?;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du produit"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              "Page Détails Produit",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "ID de l'objet reçu : $idObject",
              style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}