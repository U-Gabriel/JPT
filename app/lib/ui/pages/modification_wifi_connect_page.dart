import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../l10n/generated/app_localizations.dart';

class ModificationWifiConnectPage extends StatefulWidget {
  final int objectProfileId;
  final String title;
  final String ssid;
  final String password;
  final bool isModification;

  const ModificationWifiConnectPage({
    super.key,
    required this.objectProfileId,
    required this.title,
    required this.ssid,
    required this.password,
    this.isModification = true,
  });

  @override
  State<ModificationWifiConnectPage> createState() => _ModificationWifiConnectPageState();
}

class _ModificationWifiConnectPageState extends State<ModificationWifiConnectPage> {
  int _counter = 45;
  Timer? _timer;
  bool _isSuccess = false;
  bool _isProcessing = false;
  String _errorMessage = "";
  bool _canRetry = false;

  BluetoothDevice? _targetDevice;
  BluetoothCharacteristic? _targetCharacteristic;
  StreamSubscription<List<int>>? _lastValueSubscription;
  Timer? _retrySendTimer;

  @override
  void initState() {
    super.initState();
    _startProcess();
  }

  void _resetState() {
    if (!mounted) return;
    setState(() {
      _counter = 45;
      _isSuccess = false;
      _isProcessing = false;
      _errorMessage = "";
      _canRetry = false;
    });
  }

  void _startProcess() async {
    _resetState();

    // 1. Vérification stricte du Bluetooth
    try {
      if (!await FlutterBluePlus.isSupported) {
        _handleError("Le Bluetooth n'est pas supporté sur cet appareil.");
        return;
      }

      final state = await FlutterBluePlus.adapterState.first;
      if (state != BluetoothAdapterState.on) {
        _handleError(AppLocalizations.of(context)!.wifiErrorBluetoothOff);
        return;
      }
    } catch (e) {
      _handleError(AppLocalizations.of(context)!.wifiErrorBluetoothOff);
      return;
    }

    _startTimeoutTimer();

    // 2. Lancement du Scan
    try {
      try {
        await FlutterBluePlus.stopScan();
      } catch (_) {}

      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult r in results) {
          if (r.device.platformName.toUpperCase().contains("JACKPOT")) {
            try { FlutterBluePlus.stopScan(); } catch (_) {}
            _connectToDevice(r.device);
            break;
          }
        }
      });
    } catch (e) {
      _handleError(AppLocalizations.of(context)!.wifiErrorScanFailed);
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    _targetDevice = device;
    try {
      await device.connect(timeout: const Duration(seconds: 5));
      List<BluetoothService> services = await device.discoverServices();
      for (var s in services) {
        for (var c in s.characteristics) {
          if (c.properties.write && (c.properties.indicate || c.properties.notify)) {
            _targetCharacteristic = c;
            await c.setNotifyValue(true);
            _lastValueSubscription = c.lastValueStream.listen(_onDataReceived);
            _sendData();
            return;
          }
        }
      }
    } catch (e) {
      _handleError(AppLocalizations.of(context)!.wifiErrorConnectionLost);
    }
  }

  void _sendData() {
    if (_targetCharacteristic == null) return;

    final Map<String, dynamic> payload = {
      "id_object_profile": widget.objectProfileId,
      "ssid_wifi": widget.ssid,
      "password_wifi": widget.password,
      "is_modification": widget.isModification
    };

    final String jsonString = jsonEncode(payload);
    final bytes = utf8.encode(jsonString);

    _retrySendTimer?.cancel();

    _retrySendTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_isSuccess || _isProcessing || _errorMessage.isNotEmpty || !mounted) {
        timer.cancel();
        return;
      }
      _targetCharacteristic!.write(bytes, withoutResponse: false)
          .catchError((e) => debugPrint("Erreur write: $e"));
    });

    _targetCharacteristic!.write(bytes, withoutResponse: false)
        .catchError((e) => debugPrint("Erreur initial write: $e"));
  }

  void _onDataReceived(List<int> data) {
    if (data.isEmpty) return;
    String raw = utf8.decode(data);
    try {
      if (raw.contains('{')) {
        final decoded = jsonDecode(raw);
        if (decoded['modification_send'] != null) {
          _processResponseCode(decoded['modification_send'] as int);
        }
      } else {
        _processResponseCode(data[0]);
      }
    } catch (e) {
      debugPrint("Erreur décodage: $e");
    }
  }

  void _processResponseCode(int code) {
    if (!mounted) return;
    if (_errorMessage.contains("Profil")) return;

    setState(() {
      if (code == 2) {
        _isProcessing = true;
        _retrySendTimer?.cancel();
      } else if (code == 0) {
        _finalize(success: true);
      } else if (code == 3) {
        _timer?.cancel();
        _retrySendTimer?.cancel();

        _errorMessage = AppLocalizations.of(context)!.wifiErrorWrongProfile;
        _canRetry = false;

        Future.delayed(const Duration(milliseconds: 1000), () {
          if (_targetCharacteristic != null) {
            _targetCharacteristic!.write([10]);
          }
        });
      } else {
        if (code <= 5) {
          _finalize(success: false);
        }
      }
    });
  }

  void _finalize({required bool success}) {
    _timer?.cancel();
    _retrySendTimer?.cancel();
    if (!mounted) return;
    setState(() {
      if (success) {
        _isSuccess = true;
      } else {
        _errorMessage = AppLocalizations.of(context)!.wifiErrorConnectionFailed(widget.ssid);
        _canRetry = true;
      }
    });
  }

  void _handleError(String msg) {
    _timer?.cancel();
    _retrySendTimer?.cancel();
    if (!mounted) return;

    if (_errorMessage.contains("Profil")) return;

    setState(() {
      _errorMessage = msg;
      _canRetry = true;
    });
  }

  void _startTimeoutTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_counter > 0) {
        if (mounted) setState(() => _counter--);
      } else {
        _handleError(AppLocalizations.of(context)!.wifiErrorTimeout);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _retrySendTimer?.cancel();
    _lastValueSubscription?.cancel();
    _targetDevice?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Column(
          children: [
            _buildHeader(),
            const Spacer(),
            _buildCentralAnimation(),
            const Spacer(),
            _buildInstructions(),
            const SizedBox(height: 30),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          _isSuccess ? AppLocalizations.of(context)!.wifiConnectSuccessHeader : AppLocalizations.of(context)!.wifiConnectSearchHeader,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              widget.ssid,
              style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCentralAnimation() {
    if (_isSuccess) {
      return const Icon(Icons.check_circle_rounded, color: Colors.green, size: 120);
    }
    if (_errorMessage.isNotEmpty) {
      return const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 120);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: _counter / 45,
            strokeWidth: 10,
            color: _isProcessing ? Colors.green : Colors.blue,
            backgroundColor: Colors.grey.shade200,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("$_counter", style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Text(AppLocalizations.of(context)!.wifiConnectSeconds, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    final l10n = AppLocalizations.of(context)!;

    String title = l10n.wifiStatusSearchTitle;
    String subtitle = l10n.wifiStatusSearchSubtitle;
    Color ledColor = Colors.blue;

    if (_isProcessing) {
      title = l10n.wifiStatusProcessingTitle;
      subtitle = l10n.wifiStatusProcessingSubtitle;
      ledColor = Colors.orange;
    }
    if (_isSuccess) {
      title = l10n.wifiStatusSuccessTitle;
      subtitle = l10n.wifiStatusSuccessSubtitle;
      ledColor = Colors.green;
    }

    // CORRECTION ICI : On contrôle quel type de message est stocké dans _errorMessage
    if (_errorMessage.isNotEmpty) {
      ledColor = Colors.red;

      if (_errorMessage == l10n.wifiErrorBluetoothOff) {
        title = l10n.wifiStatusBluetoothErrorTitle;
        subtitle = l10n.wifiStatusBluetoothErrorSubtitle;
      } else if (_errorMessage.contains(l10n.wifiErrorWrongProfile)) {
        title = l10n.wifiStatusErrorTitle;
        subtitle = _errorMessage;
      } else {
        title = l10n.wifiStatusErrorTitle;
        subtitle = l10n.wifiStatusErrorSubtitleFallback;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ledColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ledColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ledColor)),
          const SizedBox(height: 10),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12, height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: ledColor, boxShadow: [BoxShadow(color: ledColor, blurRadius: 8)]),
              ),
              const SizedBox(width: 10),
              Text(AppLocalizations.of(context)!.wifiConnectLedStatus, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ledColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (_isSuccess) {
      return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.wifiConnectBtnFinish, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      );
    }

    if (_canRetry) {
      return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          onPressed: _startProcess,
          icon: const Icon(Icons.refresh, color: Colors.white),
          label: Text(AppLocalizations.of(context)!.wifiConnectBtnRetry, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      );
    }

    return Text(AppLocalizations.of(context)!.wifiConnectWait, style: const TextStyle(color: Colors.grey));
  }
}