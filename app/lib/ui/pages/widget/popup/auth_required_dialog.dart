import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../utils/app_theme_tokens.dart';

class AuthRequiredDialog extends StatelessWidget {
  const AuthRequiredDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const AuthRequiredDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône stylisée
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppT.ivory,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline, size: 32, color: AppT.gold),
            ),
            const SizedBox(height: 24),
            // Titre
            Text(
              l10n.authRequiredTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppT.ink),
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              l10n.authRequiredMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppT.muted, height: 1.5),
            ),
            const SizedBox(height: 32),
            // Actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Ferme la pop-up
                    Navigator.pushNamed(context, '/login'); // Direction Login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppT.ink,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(l10n.authRequiredBtnLogin, style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppT.muted,
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: Text(l10n.authRequiredBtnLater, style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}