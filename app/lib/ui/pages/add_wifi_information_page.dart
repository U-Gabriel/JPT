import 'package:app/ui/pages/widget/tools/step_progress_bar.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Configuration WIFI"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepProgressBar(percent: 0.50), // 50% comme demandé
            const SizedBox(height: 30),

            const Text(
              'Informations WIFI',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Pour que votre JackPote puisse communiquer avec vous, il doit être connecté à votre réseau domestique.",
              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 40),

            // Champ SSID
            const Text("Nom du réseau (SSID)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _ssidController,
              decoration: InputDecoration(
                hintText: 'Ex: MaBox_1234',
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
            const Text("Mot de passe", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Votre mot de passe wifi',
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
                      const SnackBar(content: Text("Veuillez remplir tous les champs wifi")),
                    );
                  } else {
                    // On transmet TOUT à la page suivante (ID, Nom plante, SSID, Password)
                    Navigator.pushNamed(
                      context,
                      '/next_step_route', // Remplace par ta prochaine route
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
                child: const Text("Suivant", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}