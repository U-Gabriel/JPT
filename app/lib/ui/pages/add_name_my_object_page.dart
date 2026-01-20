import 'package:app/ui/pages/widget/tools/step_progress_bar.dart';
import 'package:flutter/material.dart';

class AddNameMyObjectPage extends StatelessWidget {
  // On enlève le "final String plantType" du constructeur pour les routes nommées
  const AddNameMyObjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // On récupère l'argument ici.
    // Si jamais c'est vide, on met "la plante" par défaut pour éviter un crash.
    final Object? args = ModalRoute.of(context)!.settings.arguments;
    final String plantType = args is String ? args : "votre plante";

    return Scaffold(
      appBar: AppBar(title: const Text("Nommez votre plante")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const StepProgressBar(percent: 0.25),
            const SizedBox(height: 40),
            Text(
              "Super ! Votre $plantType a besoin d'un petit nom.",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            // Tu pourras ajouter ici ton prochain TextField pour le nom !
          ],
        ),
      ),
    );
  }
}