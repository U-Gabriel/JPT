import 'package:app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class WifiErrorDialog {
  static Future<void> show(BuildContext context, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.orange),
            const SizedBox(width: 10),
            Text(AppLocalizations.of(context)!.wifiErrorD),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            onPressed: () => Navigator.of(context).pop(), // Ferme la popup
            child: Text(AppLocalizations.of(context)!.back, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}