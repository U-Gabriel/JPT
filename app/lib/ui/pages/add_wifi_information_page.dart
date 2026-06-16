import 'package:app/ui/pages/widget/tools/step_progress_bar.dart';
import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

class AddWifiInformationPage extends StatefulWidget {
  const AddWifiInformationPage({Key? key}) : super(key: key);

  @override
  State<AddWifiInformationPage> createState() => _AddWifiInformationPageState();
}

class _AddWifiInformationPageState extends State<AddWifiInformationPage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  int? plantId;
  String? plantName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // On récupère les infos de la page précédente
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Map<String, dynamic>) {
      plantId = args['id'];
      plantName = args['name'];
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
        title: Text(localizations.wifiConfigTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepProgressBar(percent: 0.50), // 50% comme demandé
            const SizedBox(height: 30),

            Text(
              localizations.wifiInfoTitle,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              localizations.wifiInfoDescription,
              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 40),

            // Champ SSID
            Text(localizations.wifiSsidLabel, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _ssidController,
              decoration: InputDecoration(
                hintText: localizations.exampleWifiSsidLabel,
                prefixIcon: const Icon(Icons.wifi, color: Colors.green),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Champ Password
            Text(localizations.wifiPasswordLabel, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: localizations.wifiPasswordHint,
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Bouton de validation
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_ssidController.text.isEmpty || _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localizations.wifiEmptyFieldsError)),
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      '/add_connect_my_object',
                      arguments: {
                        'id': plantId,
                        'name': plantName,
                        'ssid': _ssidController.text,
                        'password': _passwordController.text,
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(localizations.nextButton, style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}