import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

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
        final l10n = AppLocalizations.of(context)!;

        // Si aucun titre/message n'est fourni par l'appelant, on utilise la traduction par défaut
        final displayTitle = title ?? l10n.connErrorDefaultTitle;
        final displayMessage = message ?? l10n.connErrorDefaultMessage;

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 10),
              Expanded(child: Text(displayTitle)), // Utilise le titre passé en paramètre
            ],
          ),
          content: Text(displayMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.connErrorBtnCancel, style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.connErrorBtnRetry, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}