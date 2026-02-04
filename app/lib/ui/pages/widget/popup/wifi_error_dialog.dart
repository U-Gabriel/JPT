import 'package:flutter/material.dart';

class WifiErrorDialog {
  static Future<void> show(BuildContext context, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.orange),
            SizedBox(width: 10),
            Text("Erreur Wi-Fi"),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            onPressed: () => Navigator.of(context).pop(), // Ferme la popup
            child: const Text("Retour", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}