import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/group_plant_service.dart';

class CreateGroupPlantPage extends StatefulWidget {
  final int objectProfileId;
  final int plantId; // Ajout du plantId requis pour l'API

  const CreateGroupPlantPage({
    super.key,
    required this.objectProfileId,
    required this.plantId
  });

  @override
  State<CreateGroupPlantPage> createState() => _CreateGroupPlantPageState();
}

class _CreateGroupPlantPageState extends State<CreateGroupPlantPage> {
  final _formKey = GlobalKey<FormState>();
  final GroupPlantService _service = GroupPlantService();
  bool _isSubmitting = false;

  // États des sélections
  int _selectedPriority = 1;
  String _selectedFertility = "45";
  int _selectedWateringSeconds = 259200; // 3 jours par défaut

  // Contrôleurs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tempController = TextEditingController(text: "");
  final TextEditingController _humidityController = TextEditingController(text: "");

  // --- DONNÉES DES OPTIONS ---
  final List<Map<String, dynamic>> _priorityOptions = [
    {"val": 1, "title": "Terre Prioritaire", "desc": "L'arrosage se base uniquement sur l'humidité du sol détectée par le capteur."},
    {"val": 2, "title": "Temps Prioritaire", "desc": "On ignore l'état de la terre, l'arrosage se fait strictement selon le calendrier."},
    {"val": 3, "title": "Terre OU Temps", "desc": "Arrose si la terre est sèche OU si le délai est dépassé. Sécurité maximale."},
    {"val": 4, "title": "Terre ET Temps", "desc": "Attend que la terre soit sèche ET que le créneau horaire soit atteint."},
    {"val": 5, "title": "Terre atteinte + Temps proche", "desc": "Priorise le capteur, mais attend d'être proche du créneau horaire prévu."},
    {"val": 6, "title": "Temps atteint + Terre proche", "desc": "Priorise le calendrier, mais vérifie que la terre n'est pas déjà trop humide."},
      ];

  final List<Map<String, String>> _fertilityOptions = [
    {"val": "20", "title": "Désertique (20%)", "desc": "Pour les cactus et plantes grasses n'aimant pas l'humidité."},
    {"val": "35", "title": "Sec (35%)", "desc": "Pour les plantes méditerranéennes (Lavande, Romarin)."},
    {"val": "45", "title": "Équilibré (45%)", "desc": "Idéal pour la majorité des plantes vertes d'intérieur."},
    {"val": "55", "title": "Humide (55%)", "desc": "Pour les plantes ayant besoin d'un sol frais constant."},
    {"val": "70", "title": "Tropical (70%)", "desc": "Fougères et plantes de jungle aimant les sols riches."},
    {"val": "85", "title": "Aquatique (85%)", "desc": "Pour les plantes de marécage ou très gourmandes."},
  ];

  final List<Map<String, dynamic>> _wateringOptions = [
    {"val": 3600, "title": "Toutes les heures"},
    {"val": 43200, "title": "Toutes les 12 heures"},
    {"val": 86400, "title": "Chaque jour"},
    {"val": 172800, "title": "Tous les 2 jours"},
    {"val": 259200, "title": "Tous les 3 jours"},
    {"val": 604800, "title": "Toutes les semaines"},
    {"val": 1209600, "title": "Toutes les 2 semaines"},
  ];

  // --- LOGIQUE DE SOUMISSION ---
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final auth = context.read<AuthProvider>();
    final token = auth.accessToken;
    final userId = int.tryParse(auth.userId ?? '') ?? 0;

    if (token == null) {
      setState(() => _isSubmitting = false);
      return;
    }

    final success = await _service.createGroup(
      idPerson: userId,
      idObjectProfile: widget.objectProfileId,
      idPlantType: widget.plantId,
      title: _nameController.text.trim(),
      fertility: double.tryParse(_selectedFertility) ?? 45.0,
      temperature: double.tryParse(_tempController.text) ?? 22.0,
      humidityAir: double.tryParse(_humidityController.text) ?? 60.0,
      priority: _selectedPriority,
      wateringTime: _selectedWateringSeconds,
      token: token,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Configuration créée avec succès !"), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la création"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Configuration Avancée", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldTitle("Nom de la configuration"),
                  _buildTextField(_nameController, "Ex: Réglages Été", Icons.label_outline),

                  const SizedBox(height: 25),
                  _buildFieldTitle("Priorité d'arrosage"),
                  _buildDropdown<int>(_selectedPriority, _priorityOptions, (val) => setState(() => _selectedPriority = val!)),
                  _buildDescription(_priorityOptions.firstWhere((e) => e['val'] == _selectedPriority)['desc']),

                  const SizedBox(height: 25),
                  _buildFieldTitle("Fréquence d'arrosage (Temps)"),
                  _buildDropdown<int>(_selectedWateringSeconds, _wateringOptions, (val) => setState(() => _selectedWateringSeconds = val!)),
                  _buildDescription("Délai maximum entre deux arrosages si la priorité inclut le facteur temps."),

                  const SizedBox(height: 25),
                  _buildFieldTitle("Objectif de Fertilité"),
                  _buildDropdown<String>(_selectedFertility, _fertilityOptions, (val) => setState(() => _selectedFertility = val!)),
                  _buildDescription(_fertilityOptions.firstWhere((e) => e['val'] == _selectedFertility)['desc']!),

                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldTitle("Température Cible"),
                            _buildTextField(_tempController, "22°C", Icons.thermostat, isNumber: true),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldTitle("Humidité Cible"),
                            _buildTextField(_humidityController, "60%", Icons.air, isNumber: true),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  _buildSubmitButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          if (_isSubmitting)
            Container(
              color: Colors.black12,
              child: const Center(child: CircularProgressIndicator(color: Colors.green)),
            ),
        ],
      ),
    );
  }

  // --- COMPOSANTS D'INTERFACE ---

  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
    );
  }

  Widget _buildDescription(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic)),
    );
  }

  Widget _buildDropdown<T>(T value, List<Map<String, dynamic>> options, ValueChanged<T?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.green, size: 20),
          items: options.map((opt) {
            return DropdownMenuItem<T>(
              value: opt['val'] as T,
              child: Text(opt['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            );
          }).toList(),
          onChanged: _isSubmitting ? null : onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) => value == null || value.isEmpty ? "Champ requis" : null,
      enabled: !_isSubmitting,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.green),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.green, width: 2)),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
        ),
        child: Text(
          _isSubmitting ? "ENREGISTREMENT..." : "CRÉER LA CONFIGURATION",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}