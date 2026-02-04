import 'dart:convert';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDiscoveryService {

  BluetoothCharacteristic? _targetCharacteristic;

  // Configuration
  static const String deviceName = "JACKPOTE_OBJECT_1";
  static const String targetCharUuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  // Contrôleurs de flux
  final StreamController<Map<String, dynamic>?> _objectIdController = StreamController<Map<String, dynamic>?>.broadcast();
  final StreamController<String?> _errorController = StreamController<String?>.broadcast();

  Stream<Map<String, dynamic>?> get objectIdStream => _objectIdController.stream;
  Stream<String?> get errorStream => _errorController.stream;

  StreamSubscription? _scanSubscription;
  bool _isFound = false;

  void startSearching() async {
    _isFound = false;

    // 1. Arrêter tout scan ou connexion en cours pour repartir à zéro
    await FlutterBluePlus.stopScan();

    // 2. Vérifier l'état du Bluetooth
    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      _errorController.add("Veuillez activer le Bluetooth.");
      return;
    }

    // 3. Lancer le scan
    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 30),
        androidUsesFineLocation: true,
      );
    } catch (e) {
      _errorController.add("Impossible de démarrer le scan.");
      return;
    }

    // 4. Écouter les résultats
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
      if (_isFound) return;

      for (ScanResult r in results) {
        if (r.device.platformName == deviceName) {
          _isFound = true;
          await FlutterBluePlus.stopScan();
          await _connectToDevice(r.device);
          break;
        }
      }
    });

    // Gestion du Timeout
    Future.delayed(const Duration(seconds: 16), () {
      if (!_isFound && !_objectIdController.isClosed) {
        _errorController.add("Aucun objet Jackpote détecté à proximité.");
      }
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false).timeout(const Duration(seconds: 10));

      // Laisser le temps à l'ESP32 de stabiliser la connexion
      await Future.delayed(const Duration(milliseconds: 500));

      List<BluetoothService> services = await device.discoverServices();
      await Future.delayed(const Duration(milliseconds: 500));

      for (var service in services) {
        for (var characteristic in service.characteristics) {
          print("UUID Trouvé : ${characteristic.uuid.toString()}");
          if (characteristic.uuid.toString().toLowerCase() == targetCharUuid) {
            //GARDER LA RÉFÉRENCE ICI
            _targetCharacteristic = characteristic;

            // Lecture des données
            List<int> value = await characteristic.read().timeout(const Duration(seconds: 5));
            String rawJson = utf8.decode(value);

            // Parsing JSON sécurisé
            try {
              final data = jsonDecode(rawJson);
              if (data is Map && data.containsKey('id_object')) {
                // ON ENVOIE TOUT LE PAQUET À LA PAGE (id_object ET id_object_profile)
                _objectIdController.add({
                  'id_object': data['id_object'],
                  'id_object_profile': data['id_object_profile'] ?? 0,
                });
              } else {
                _errorController.add("Données reçues invalides.");
              }
            } catch (e) {
              _errorController.add("Erreur de formatage des données.");
            }

            // Une fois lu, on se déconnecte pour économiser l'énergie (Optionnel)
            // await device.disconnect();
            return;
          }
        }
      }
      _errorController.add("Service Jackpote non trouvé sur cet appareil.");
    } catch (e) {
      _isFound = false;
      _errorController.add("Échec de la connexion à l'objet.");
    }
  }

  Future<bool> sendWifiData(String jsonPayload) async {
    if (_targetCharacteristic == null) return false;

    try {
      // Conversion du texte JSON en liste d'octets (bytes)
      List<int> bytes = utf8.encode(jsonPayload);

      // Envoi à l'ESP32
      await _targetCharacteristic!.write(bytes);
      print("JSON envoyé avec succès à l'objet");
      return true;
    } catch (e) {
      print("Erreur lors de l'envoi Bluetooth : $e");
      return false;
    }
  }

  Future<int?> sendWifiAndGetStatus(String jsonPayload) async {
    if (_targetCharacteristic == null) return null;

    final Completer<int> resultCompleter = Completer<int>();
    StreamSubscription? subscription;

    try {
      await _targetCharacteristic!.setNotifyValue(true);

      // 1. On prépare l'écoute précise
      subscription = _targetCharacteristic!.lastValueStream.listen((value) {
        if (value.isNotEmpty) {
          int status = value[0];
          print("Notification reçue : $status");

          if (status == 0 || status == 1) {
            if (!resultCompleter.isCompleted) {
              resultCompleter.complete(status);
            }
          }
        }
      });

      // 2. Envoi du JSON
      await _targetCharacteristic!.write(utf8.encode(jsonPayload), timeout: 10);
      print("Paquet envoyé, attente du résultat final...");

      // 3. Attente avec un gros timeout de 45s (pour laisser l'ESP bosser)
      return await resultCompleter.future.timeout(const Duration(seconds: 45));

    } catch (e) {
      print("Erreur pendant l'attente : $e");
      return null;
    } finally {
      // Toujours nettoyer la souscription
      await subscription?.cancel();
    }
  }
  void dispose() {
    _scanSubscription?.cancel();
    _objectIdController.close();
    _errorController.close();
  }
}