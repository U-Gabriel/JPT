import 'package:flutter/material.dart';

class DeleteConfirmDialog {
  static void show(
      BuildContext context, {
        required String groupTitle,
        required VoidCallback onConfirm,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Confirmer la suppression"),
          content: Text("Voulez-vous vraiment supprimer le groupe '$groupTitle' ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la popup
                onConfirm();           // Exécuter la fonction passée en paramètre
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