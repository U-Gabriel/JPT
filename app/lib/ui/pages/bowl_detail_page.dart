import 'package:app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class BowlDetailPage extends StatelessWidget {
  final int objectProfileId;

  const BowlDetailPage({Key? key, required this.objectProfileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.detailsBowlsD),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 16),
            Text(
              localizations.bowlPageProfileId(objectProfileId.toString()),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(localizations.specificAnimalDesignWillBeHere, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}