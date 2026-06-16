import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

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
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.connErrorBtnCancel, style: TextStyle(color: Colors.grey)),
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
              child: Text(AppLocalizations.of(context)!.deleteD, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}