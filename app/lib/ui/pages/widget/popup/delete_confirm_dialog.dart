import 'package:flutter/material.dart';

class DeleteConfirmDialog {
  static void show(
      BuildContext context, {
        required String title,
        required String message,
        required VoidCallback onConfirm,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la popup
                onConfirm();           // Exécuter l'action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Supprimer", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}