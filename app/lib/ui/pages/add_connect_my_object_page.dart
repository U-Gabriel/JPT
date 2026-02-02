import 'package:app/ui/pages/widget/popup/connection_error_dialog.dart';
import 'package:app/ui/pages/widget/tools/step_progress_bar.dart';
import 'package:flutter/material.dart';
import 'widget/tools/bluetooth_discovery_service.dart';

class AddConnectMyObjectPage extends StatefulWidget {
  const AddConnectMyObjectPage({Key? key}) : super(key: key);

  @override
  State<AddConnectMyObjectPage> createState() => _AddConnectMyObjectPageState();
}

class _AddConnectMyObjectPageState extends State<AddConnectMyObjectPage> {

  final BluetoothDiscoveryService _btService = BluetoothDiscoveryService();

  int? plantId;
  String plantName = "votre plante";
  String? ssid;
  String? password;

  int? objectId;
  bool isSearching = true;

  @override
  void initState() {
    super.initState();
    _setupBluetoothListeners();
    _btService.startSearching();
  }

  void _setupBluetoothListeners() {
    // Écoute du succès
    _btService.objectIdStream.listen((id) {
      if (mounted) {
        setState(() {
          objectId = id;
          isSearching = false;
        });
      }
    });

    // Écoute des erreurs avec la Pop-up
    _btService.errorStream.listen((errorMessage) async {
      if (mounted && errorMessage != null) {

        // On affiche la pop-up et on attend la réponse (true ou false)
        bool? retry = await ConnectionErrorDialog.show(context, message: errorMessage);

        if (retry == true) {
          // Option "Réessayer"
          setState(() => isSearching = true);
          _btService.startSearching();
        } else {
          // Option "Annuler"
          if (mounted) Navigator.of(context).pop(); // Retour à la page précédente
        }
      }
    });
  }

  @override
  void dispose() {
    _btService.dispose(); // Très important pour éviter les fuites de mémoire
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // On récupère TOUTES les infos transmises par la page WIFI
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args is Map<String, dynamic>) {
      setState(() {
        plantId = args['id'];
        plantName = args['name'] ?? "votre plante";
        ssid = args['ssid'];
        password = args['password'];
      });
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
        title: const Text("Connexion"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepProgressBar(percent: 0.75), // On avance à 75%
            const SizedBox(height: 30),

            const Text(
              'Connectons votre objet !',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Text(
              "Nous allons enfin pouvoir connecter votre $plantName à notre objet. Appuyez sur le bouton bleu de l'objet pour que notre aplication puisse le détecter. ",
              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            ),

            const SizedBox(height: 40),

            // Petit récapitulatif visuel (Optionnel mais pro)
            // Dans ton build, remplace le Container précédent par celui-ci :
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildRecapRow(Icons.local_florist, "Plante", plantName),
                  const Divider(),
                  _buildRecapRow(Icons.wifi, "Réseau", ssid ?? "Inconnu"),
                  const Divider(),

                  // --- NOUVELLE SECTION BLUETOOTH ---
                  isSearching
                      ? Column(
                    children: [
                      const SizedBox(height: 10),
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green)
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Veuillez patienter en attendant la connexion...",
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black54),
                      ),
                    ],
                  )
                      : _buildRecapRow(Icons.bluetooth_connected, "ID Objet", objectId.toString()),
                ],
              ),
            ),

            const Spacer(),

            // Le bouton final qui lancera l'action
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                // On désactive le bouton (onPressed = null) si on cherche encore
                onPressed: isSearching ? null : () {
                  print("Prêt à connecter : ID $plantId sur $ssid avec l'objet $objectId");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSearching ? Colors.grey : Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                    isSearching ? "Recherche de l'objet..." : "Lancer la connexion",
                    style: const TextStyle(fontSize: 18, color: Colors.white)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecapRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green[700], size: 20),
          const SizedBox(width: 12),
          Text("$label : ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}