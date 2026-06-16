import 'package:flutter/material.dart';
import 'package:app/ui/pages/widget/tools/step_progress_bar.dart';

import '../../app_config.dart';
import '../../l10n/generated/app_localizations.dart';

class AddNameSpeMyObjectPage extends StatefulWidget {
  const AddNameSpeMyObjectPage({Key? key}) : super(key: key);

  @override
  State<AddNameSpeMyObjectPage> createState() => _AddNameSpeMyObjectPageState();
}

class _AddNameSpeMyObjectPageState extends State<AddNameSpeMyObjectPage> {
  final TextEditingController _nameController = TextEditingController();

  String objectTitle = "Votre objet";
  int? plantId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Map<String, dynamic>) {
      plantId = args['id'];
      setState(() {
        objectTitle = args['title'] ?? AppLocalizations.of(context)!.defaultObjectTitle;;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(localizations.customConfigTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepProgressBar(percent: 0.25),
            const SizedBox(height: 40),

            // 1. En-tête épuré et moderne
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.developer_board, size: 48, color: Colors.blueGrey[700]),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                localizations.customConfigGiveNameTitle,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                localizations.customConfigGiveNameDescription,
                style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),

            // 2. Champ de saisie obligatoire
            RichText(
              text: TextSpan(
                text: localizations.customConfigInputLabel,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                children: const [
                  TextSpan(text: " *", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: localizations.customConfigInputHint,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.router, color: Colors.blueGrey),
              ),
            ),

            const SizedBox(height: 100), // Laisse de l'espace pour équilibrer le manque de description

            // 3. Bouton de validation (garde la même suite de tunnel)
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(localizations.customConfigEmptyNameError),
                          backgroundColor: Colors.red
                      ),
                    );
                  } else {
                    // Envoie vers la suite du tunnel existant (la page wifi) avec les mêmes clés !
                    Navigator.pushNamed(
                      context,
                      '/add_wifi_information',
                      arguments: {
                        'id': plantId ?? AppConfig.defaultPlantId,
                        'name': _nameController.text.trim(),
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[800], // Teinte légèrement différente pour marquer le côté "hardware/libre"
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(localizations.continueButton, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}