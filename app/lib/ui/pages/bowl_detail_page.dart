import 'package:flutter/material.dart';

class BowlDetailPage extends StatelessWidget {
  final int objectProfileId;

  const BowlDetailPage({Key? key, required this.objectProfileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Détails Gamelle (Bowl)"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 16),
            Text(
              "Page Gamelle - Profil ID: $objectProfileId",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Le design spécifique des animaux sera intégré ici.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}