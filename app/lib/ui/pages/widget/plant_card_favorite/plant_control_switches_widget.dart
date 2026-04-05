import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour le retour haptique
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../services/object_profile_service.dart';
import '../../../../models/object_profile.dart';

class PlantControlSwitches extends StatefulWidget {
  final ObjectProfile plant;

  const PlantControlSwitches({Key? key, required this.plant}) : super(key: key);

  @override
  State<PlantControlSwitches> createState() => _PlantControlSwitchesState();
}

class _PlantControlSwitchesState extends State<PlantControlSwitches> {
  bool _isWatering = false;

  // Fonction pour afficher l'explication si le mode auto est activé
  void _showDisabledReason(String content_text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content_text,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _startWatering() async {
    final bool isStable = _isConnectionStable(widget.plant.lastWatering) || _isConnectionStable(widget.plant.lastUpdate);

    // Si le mode auto est actif, on n'arrose pas, on explique pourquoi
    if (widget.plant.isAutomatic == true) {
      _showDisabledReason("Arrosage manuel indisponible : le mode automatique gère déjà votre plante de façon optimale.");
      return;
    }

    if (!isStable) {
      _showDisabledReason("Impossible d'arroser : l'objet est hors ligne.");
      return;
    }

    if (_isWatering) return;

    HapticFeedback.mediumImpact();
    setState(() => _isWatering = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.accessToken;
    final userId = int.tryParse(authProvider.userId ?? '') ?? 0;

    if (token == null) return;

    try {
      await ObjectProfileService().updateObjectProfile(
        idPerson: userId,
        idObjectProfile: widget.plant.idObjectProfile,
        otherFields: {"is_water": true},
        token: token,
      );

      Timer(const Duration(seconds: 30), () {
        if (mounted) setState(() => _isWatering = false);
      });
    } catch (e) {
      setState(() => _isWatering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // On récupère l'état automatique
    final bool isAuto = widget.plant.isAutomatic ?? false;

    return Column(
      children: [
        _buildWaterButton(isAuto),
      ],
    );
  }

  Widget _buildWaterButton(bool isAuto) {
    // Couleurs selon l'état : En cours, Désactivé (Auto), ou Prêt
    Color buttonColor;
    if (_isWatering) {
      buttonColor = Colors.blue[100]!;
    } else if (isAuto) {
      buttonColor = Colors.grey[300]!; // Grisé si automatique
    } else {
      buttonColor = Colors.blue[600]!;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: (_isWatering || isAuto)
            ? []
            : [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _startWatering, // La logique de tri est gérée dans la fonction
          child: Center(
            child: _buildButtonContent(isAuto),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(bool isAuto) {
    if (_isWatering) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue)),
          const SizedBox(width: 15),
          Text("ARROSAGE EN COURS...", style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
        ],
      );
    }

    if (isAuto) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, color: Colors.grey[600]), // Icône de verrou
          const SizedBox(width: 10),
          Text(
            "ARROSAGE AUTOMATIQUE",
            style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.water_drop, color: Colors.white),
        SizedBox(width: 10),
        Text("LANCER L'ARROSAGE", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  bool _isConnectionStable(String? lastWatering) {
    if (lastWatering == null) return false;
    try {
      final lastDate = DateTime.parse(lastWatering);
      final difference = DateTime.now().difference(lastDate).inDays;
      return difference <= 7;
    } catch (e) {
      return false;
    }
  }
}