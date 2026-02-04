import 'package:flutter/material.dart';

class SuccessDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required String routeName, // Le chemin de redirection
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // L'utilisateur doit cliquer sur le bouton
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 30),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                // On ferme la popup ET on redirige
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                      (route) => false, // Cette condition 'false' dit de supprimer TOUTES les pages précédentes
                );
              },
              child: const Text("Valider", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}