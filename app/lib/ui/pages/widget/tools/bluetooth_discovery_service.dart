import 'dart:convert';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDiscoveryService {
  final StreamController<int?> _objectIdController = StreamController<int?>();
  final StreamController<String?> _errorController = StreamController<String?>();

  // Flux pour l'ID de l'objet
  Stream<int?> get objectIdStream => _objectIdController.stream;
  // Flux pour les messages d'erreur à afficher à l'utilisateur
  Stream<String?> get errorStream => _errorController.stream;

  final String targetCharacteristicUuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  void startSearching() async {
    await FlutterBluePlus.stopScan();
    bool found = false;

    try {
      // PRO : On demande au téléphone de filtrer DIRECTEMENT par UUID au niveau du scan
      // Cela évite de réveiller ton code pour les écouteurs du voisin.
      await FlutterBluePlus.startScan(
        withServices: [Guid("0000180d-0000-1000-8000-00805f9b34fb")], // <--- TON SERVICE UUID ICI
        timeout: const Duration(seconds: 15),
        androidUsesFineLocation: true,
      );
    } catch (e) {
      _errorController.add("Erreur scan: $e");
      return;
    }

    // Timer de sécurité si rien n'est trouvé
    Future.delayed(const Duration(seconds: 16), () {
      if (!found && !_objectIdController.isClosed) {
        _errorController.add("Aucun objet détecté.");
      }
    });

    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        // On vérifie le nom OU l'UUID pour être sûr à 100%
        if (r.device.platformName.startsWith("JACKPOTE_OBJECT") || found == false) {
          found = true;
          await FlutterBluePlus.stopScan();

          try {
            await r.device.connect().timeout(const Duration(seconds: 25));

            // Une fois connecté, on cherche notre caractéristique
            List<BluetoothService> services = await r.device.discoverServices();
            for (var service in services) {
              for (var characteristic in service.characteristics) {
                if (characteristic.uuid.toString() == targetCharacteristicUuid) {
                  // LECTURE DU JSON
                  List<int> value = await characteristic.read();
                  String rawJson = utf8.decode(value);
                  final data = jsonDecode(rawJson);

                  _objectIdController.add(data['id_object']);
                }
              }
            }
          } catch (e) {
            _errorController.add("Erreur : $e");
            r.device.disconnect();
          }
        }
      }
    });
  }

  void dispose() {
    _objectIdController.close();
    _errorController.close();
  }
}