import 'dart:async';
import 'dart:convert';
import 'package:app/ui/pages/widget/popup/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/ui/pages/widget/controllers/object_connection_controller.dart';
import 'package:app/ui/pages/widget/popup/connection_error_dialog.dart';
import 'package:app/ui/pages/widget/popup/wifi_error_dialog.dart';
import 'package:app/ui/pages/widget/tools/step_progress_bar.dart';
import '../../services/object_profile_service.dart';
import 'widget/tools/bluetooth_discovery_service.dart';

class AddConnectMyObjectPage extends StatefulWidget {
  const AddConnectMyObjectPage({Key? key}) : super(key: key);

  @override
  State<AddConnectMyObjectPage> createState() => _AddConnectMyObjectPageState();

}

class _AddConnectMyObjectPageState extends State<AddConnectMyObjectPage> {

  final BluetoothDiscoveryService _btService = BluetoothDiscoveryService();
  final ObjectProfileService _profileService = ObjectProfileService();

  StreamSubscription? _idSub;
  StreamSubscription? _errSub;

  final ObjectConnectionController _connectionController = ObjectConnectionController();
  bool isCreatingProfile = false;
  int? objectProfileId;

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
    _idSub = _btService.objectIdStream.listen((data) async {
      if (mounted && data != null) {
        int receivedObjectId = data['id_object'];
        int existingProfileId = data['id_object_profile'];

        // --- LOGIQUE DE VÉRIFICATION INTELLIGENTE ---
        if (existingProfileId != 0) {
          setState(() => isSearching = false);

          try {
            final auth = Provider.of<AuthProvider>(context, listen: false);
            // On vérifie si ce profil existe vraiment encore pour quelqu'un
            final profile = await _profileService.fetchObjectProfileDetails(existingProfileId, auth.accessToken!);

            // SI ON ARRIVE ICI, LE PROFIL EXISTE VRAIMENT EN BDD
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AlertDialog(
                title: const Text("Objet déjà associé"),
                content: Text("Cet objet est déjà lié à la fleur '${profile.title}'.\n\nVeuillez d'abord supprimer la fleur associée dans vos paramètres."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    child: const Text("COMPRIS"),
                  ),
                ],
              ),
            );
            return; // Blocage réel car le profil existe en BDD

          } catch (e) {
            // SI ON ARRIVE ICI (Erreur 404 ou autre), le profil n'existe plus en BDD
            // L'objet est orphelin : ON CONTINUE LA CONNEXION NORMALEMENT
            print("L'objet avait l'ID $existingProfileId mais il n'existe plus en BDD. On écrase.");
          }
        }

        // --- SI L'OBJET EST NEUF (0) OU ORPHELIN (ID INEXISTANT EN BDD) ---
        setState(() {
          objectId = receivedObjectId;
          isSearching = false;
        });

        _handleAutoCreate();
      }
    });
      // Écoute des erreurs avec la Pop-up
      _errSub = _btService.errorStream.listen((errorMessage) async {
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
    _idSub?.cancel();
    _errSub?.cancel();
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
      body: SingleChildScrollView(
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
                  (isSearching || isCreatingProfile)
                      ? Column(
                    children: [
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(strokeWidth: 2, color: Colors.green),
                      const SizedBox(height: 10),
                      Text(
                        isCreatingProfile
                            ? "Création de votre profil plante..."
                            : "Recherche de l'objet...",
                        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black54),
                      ),
                    ],
                  )
                      : _buildRecapRow(Icons.bluetooth_connected, "ID Objet", objectId.toString()),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Le bouton final qui lancera l'action
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                // On active SEULEMENT si on ne cherche plus ET que le profil est créé
                onPressed: (isSearching || isCreatingProfile || objectProfileId == null)
                    ? null
                    : () {
                  print("Action finale avec Profile ID: $objectProfileId");
                  // C'est ici qu'on enverra le WIFI plus tard
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: (isSearching || isCreatingProfile || objectProfileId == null)
                      ? Colors.grey
                      : Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                    isSearching
                        ? "Recherche..."
                        : (isCreatingProfile ? "Création profil..." : "Lancer la connexion"),
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

  Future<void> _handleAutoCreate() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final token = auth.accessToken ?? "";
    final int userId = int.tryParse(auth.userId ?? "") ?? 0;

    // 1. On affiche le loader
    setState(() => isCreatingProfile = true);

    // --- ÉTAPE 1 : CRÉATION DU PROFIL EN BDD D'ABORD ---
    print("Étape 1 : Création du profil en base de données...");

    final int? newId = await _connectionController.createProfile(
      context: context,
      title: plantName,
      idObject: objectId!,
      idPlantType: plantId!,
      idPerson: userId,
      token: token,
    );

    if (newId == null) {
      // Si l'API échoue, on arrête tout (le controller affiche déjà l'erreur)
      setState(() => isCreatingProfile = false);
      return;
    }

    // --- ÉTAPE 2 : TEST DU WIFI SUR L'OBJET AVEC LE VRAI ID ---
    print("Étape 2 : Profil créé (ID: $newId). Envoi des infos à l'objet...");

    final Map<String, dynamic> testPayload = {
      "id_object_profile": newId, // ON ENVOIE LE VRAI ID MAINTENANT !
      "ssid_wifi": ssid,
      "password_wifi": password,
    };

    // On met en pause les erreurs Bluetooth auto le temps du test
    _errSub?.pause();

    int? wifiStatus = await _btService.sendWifiAndGetStatus(jsonEncode(testPayload));

    if (!mounted) return;
    setState(() => isCreatingProfile = false);

    if (wifiStatus == 0) {
      // SUCCÈS TOTAL : OBJET CONNECTÉ + ID SAUVÉ DANS L'ESP32
      print("Wi-Fi OK. Activation du profil $newId...");

      bool activated = await _profileService.updateObjectProfile(
        idPerson: userId,
        idObjectProfile: newId,
        otherFields: {"activate": 1}, // <--- C'est ici que c'est dynamique
        token: token,
      );

      setState(() => isCreatingProfile = false);

      if (activated) {
        // SUCCÈS TOTAL
        await SuccessDialog.show(
          context: context,
          title: "Félicitations !",
          message: "Votre $plantName est configurée et activée !",
          routeName: "/",
        );
      } else {

        print("Échec Wi-Fi. Rollback...");
        await _profileService.deleteObjectProfile(idPerson: userId, idObjectProfile: newId, token: token);

        _errSub?.resume();

        await ConnectionErrorDialog.show(context, message: "L'objet ne répond plus. Profil annulé.");

        if (mounted) Navigator.of(context).pop();
      }

    }
    else {
      // --- ÉCHEC : ROLLBACK (SUPPRESSION) ---
      print("Échec Wi-Fi. Suppression du profil $newId en cours...");

      await _profileService.deleteObjectProfile(
        idPerson: userId,
        idObjectProfile: newId,
        token: token,
      );

      setState(() => isCreatingProfile = false);
      _errSub?.resume();

      if (wifiStatus == 1) {
        await WifiErrorDialog.show(
            context,
            "L'objet n'a pas pu se connecter au Wi-Fi. Le profil a été annulé."
        );
      } else {
        ConnectionErrorDialog.show(
          context,
          message: "L'objet ne répond plus. Connexion annulée.",
        );
      }

      if (mounted) Navigator.of(context).pop();
    }
  }
}