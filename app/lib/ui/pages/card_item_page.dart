import 'package:flutter/material.dart';

class CardItemPage extends StatelessWidget {
  const CardItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Panier"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Votre panier est vide pour le moment",
          style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}