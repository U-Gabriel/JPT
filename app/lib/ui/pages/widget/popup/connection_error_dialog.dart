import 'package:flutter/material.dart';

class ConnectionErrorDialog {
  static Future<bool?> show(BuildContext context, {required String message}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // L'utilisateur doit obligatoirement cliquer sur un bouton
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 10),
              Text("Erreur de connexion"),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Retourne false
              child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(context).pop(true), // Retourne true
              child: const Text("Réessayer", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}