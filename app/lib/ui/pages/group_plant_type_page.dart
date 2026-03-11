import 'package:app/ui/pages/widget/popup/delete_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/plant_group.dart';
import '../../../services/group_plant_service.dart';

class GroupPlantTypePage extends StatefulWidget {
  final int objectProfileId;
  const GroupPlantTypePage({super.key, required this.objectProfileId});

  @override
  State<GroupPlantTypePage> createState() => _GroupPlantTypePageState();
}

class _GroupPlantTypePageState extends State<GroupPlantTypePage> {
  final GroupPlantService _service = GroupPlantService();
  List<PlantGroup> _groups = [];
  PlantGroup? _selectedGroup;
  PlantGroup? _activeGroup;
  bool _isLoading = true;

  // --- INITIALISATION ---

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final auth = context.read<AuthProvider>();
    final token = auth.accessToken;
    final userId = int.tryParse(auth.userId ?? '') ?? 0;

    if (token != null) {
      final result = await _service.getGroupsResume(userId, widget.objectProfileId, token);
      setState(() {
        _groups = result;
        if (_groups.isNotEmpty) {
          _activeGroup = _groups.first;
          _selectedGroup = _groups.first;
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Réglages Automatiques",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 25),
            _buildCreateButton(),
            const SizedBox(height: 25),
            const Text("Choisir un groupe de paramètres",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            _buildDropdown(),
            const SizedBox(height: 30),
            if (_selectedGroup != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Détails du groupe",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  if (_selectedGroup!.isStandard)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text("STANDARD PLANTE",
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const SizedBox(height: 15),
              _buildDetailsGrid(),
              const SizedBox(height: 40),
              _buildActionButtons(),
              const SizedBox(height: 20),

            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return InkWell(
      onTap: () => Navigator.pushNamed(
          context,
          '/create_group_plant',
          arguments: widget.objectProfileId
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Configuration personnalisée",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text("Créez vos propres règles d'arrosage",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mode Automatique Intelligent",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Nous appliquons les réglages ci-dessous pour garantir la santé de votre plante. Grâce à cela l'objet optimise les calculs et sait les valeurs cble à atteindre.",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _selectedGroup?.isStandard == true ? Colors.green : Colors.grey[200]!, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PlantGroup>(
          value: _selectedGroup,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.green),
          items: _groups.map((group) {
            bool isActive = group.idGroup == _activeGroup?.idGroup;
            return DropdownMenuItem(
              value: group,
              child: Row(
                children: [
                  Text(group.title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.green : Colors.black87
                      )
                  ),
                  if (isActive) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  ]
                ],
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedGroup = val),
        ),
      ),
    );
  }

  Widget _buildDetailsGrid() {
    final d = _selectedGroup!.details;
    return Column(
      children: [
        _buildInfoTile("Nom de la configuration", _selectedGroup!.title, Icons.label_important_outline),
        const SizedBox(height: 12),
        _buildInfoTile("Objectif Fertilité", _getFertilityText(d.fertility), Icons.opacity, trailing: "${d.fertility}%"),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInfoTile("Température", "${d.temperature ?? '--'}°C", Icons.thermostat)),
            const SizedBox(width: 12),
            Expanded(child: _buildInfoTile("Humidité Air", "${d.humidityAir ?? '--'}%", Icons.air)),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoTile("Priorité d'arrosage", _getPriorityText(d.priority), Icons.star_outline),
        const SizedBox(height: 12),
        _buildInfoTile("Fréquence d'arrosage", _formatWateringTime(d.wateringTime), Icons.event_repeat),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon, {String? trailing}) {
    bool isStandard = _selectedGroup?.isStandard ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isStandard ? Colors.green.withOpacity(0.3) : Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: isStandard ? Colors.green : Colors.green[300], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.bold)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
          if (trailing != null)
            Text(trailing, style: TextStyle(color: Colors.grey[400], fontSize: 12, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    bool isStandard = _selectedGroup?.isStandard ?? false;
    // On vérifie si le groupe sélectionné est déjà celui qui est actif
    bool isAlreadyActive = _selectedGroup?.idGroup == _activeGroup?.idGroup;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            // Si déjà actif, onPressed est null (ce qui grise le bouton automatiquement)
            onPressed: isAlreadyActive ? null : () => _handleAssignGroup(),
            icon: Icon(
                isAlreadyActive ? Icons.verified : Icons.check_circle_outline,
                color: Colors.white
            ),
            label: Text(
              isAlreadyActive ? "Déjà configuré sur cet objet" : "Assigner ce groupe à mon objet",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              // On gère la couleur "grisée" manuellement pour le design
              backgroundColor: isAlreadyActive ? Colors.grey[400] : Colors.green,
              disabledBackgroundColor: Colors.grey[400], // Sécurité Flutter
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: isAlreadyActive ? 0 : 2,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Sécurité : On ne supprime pas un groupe standard, NI le groupe actuellement actif !
        if (!isStandard && !isAlreadyActive)
          TextButton.icon(
            onPressed: () {
              // On appelle notre classe Helper
              DeleteConfirmDialog.show(
                context,
                groupTitle: _selectedGroup!.title,
                onConfirm: () => _handleDeleteGroup(),
              );
            },
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            label: const Text("Supprimer ce groupe personnalisé"),
          )
        else if (isAlreadyActive)
          const Text(
            "Impossible de supprimer le groupe actif",
            style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
          )
        else
          const Text(
            "Les groupes standards ne peuvent pas être supprimés",
            style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
          ),
      ],
    );
  }

  // Fonction d'appel api


  Future<void> _handleDeleteGroup() async {
    if (_selectedGroup == null) return;

    final auth = context.read<AuthProvider>();
    final token = auth.accessToken;
    final userId = int.tryParse(auth.userId ?? '') ?? 0;

    if (token == null) return;

    // 1. Afficher un indicateur de chargement
    setState(() => _isLoading = true);

    // 2. Appel au service
    final success = await _service.deleteGroup(userId, _selectedGroup!.idGroup, token);

    if (success) {
      // 3. Rafraîchir la liste localement
      await _loadGroups();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Groupe supprimé avec succès"), backgroundColor: Colors.green),
        );
      }
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la suppression"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _handleAssignGroup() async {
    if (_selectedGroup == null) return;

    final auth = context.read<AuthProvider>();
    final token = auth.accessToken;
    final userId = int.tryParse(auth.userId ?? '') ?? 0;

    if (token == null) return;

    setState(() => _isLoading = true);

    final success = await _service.assignGroup(
      idPerson: userId,
      idObjectProfile: widget.objectProfileId,
      idGroup: _selectedGroup!.idGroup,
      isStandard: _selectedGroup!.isStandard,
      token: token,
    );

    if (success) {
      // Recharger les groupes pour que le nouveau groupe assigné remonte en 1ère position (actif)
      await _loadGroups();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_selectedGroup!.isStandard ? "Mode standard activé" : "Paramètres appliqués avec succès"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'assignation"), backgroundColor: Colors.red),
        );
      }
    }
  }

  ////////



  // --- LOGIQUE DE TRADUCTION ---

  String _getFertilityText(String? value) {
    final val = double.tryParse(value ?? '') ?? 0;
    if (val <= 25) return "Sol aride";
    if (val <= 35) return "Sol sec";
    if (val <= 60) return "Sol humide";
    if (val <= 80) return "Sol très humide";
    if (val <= 90) return "Sol très riche";
    return "Excès de nutriments";
  }

  String _getPriorityText(int? priority) {
    switch (priority) {
      case 1: return "Terre (Capteur)";
      case 2: return "Temps (Calendrier)";
      case 3: return "Terre ou Temps";
      case 4: return "Terre et Temps";
      case 5: return "Terre atteint + Temps proche";
      case 6: return "Temps atteint + Terre proche";
      default: return "Non défini";
    }
  }

  String _formatWateringTime(int? seconds) {
    if (seconds == null || seconds == 0) return "Pas d'arrosage planifié";
    final duration = Duration(seconds: seconds);
    if (duration.inDays >= 7) {
      double weeks = duration.inDays / 7;
      return "Tous les ${weeks.toStringAsFixed(weeks.truncateToDouble() == weeks ? 0 : 1)} semaines";
    }
    if (duration.inDays >= 1) return "Tous les ${duration.inDays} jours";
    return "Toutes les ${duration.inHours} heures";
  }
}