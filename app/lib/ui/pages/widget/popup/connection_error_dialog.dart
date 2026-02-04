import 'package:flutter/material.dart';
import 'package:app/services/object_profile_service.dart';
import 'package:app/ui/pages/widget/popup/connection_error_dialog.dart';

class ConnectionErrorDialog {
  static Future<bool?> show(
      BuildContext context, {
        required String message,
        String title = "Erreur de connexion", // Titre par défaut
      }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 10),
              Expanded(child: Text(title)), // Utilise le titre passé en paramètre
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Réessayer", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}