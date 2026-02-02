import 'package:flutter/material.dart';

class BuyMyObjectPage extends StatelessWidget {
  const BuyMyObjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Boutique JackPote")),
      body: const Center(
        child: Text(
          "Bienvenue dans la boutique !\nDécouvrez nos pots connectés.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}